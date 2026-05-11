import prisma from '../config/database.js';

export const getSales = async (req, res, next) => {
    try {
        const { startDate, endDate } = req.query;
        
        const where = {};
        if (startDate && endDate) {
            where.date = {
                gte: new Date(startDate),
                lte: new Date(endDate)
            };
        }
        
        const sales = await prisma.sale.findMany({
            where,
            include: {
                items: {
                    include: {
                        product: true
                    }
                }
            },
            orderBy: { date: 'desc' }
        });
        
        res.json({
            status: 'success',
            data: { sales }
        });
    } catch (error) {
        next(error);
    }
};

export const getSaleById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const sale = await prisma.sale.findUnique({
            where: { id },
            include: {
                items: {
                    include: {
                        product: true
                    }
                }
            }
        });
        
        if (!sale) {
            return res.status(404).json({ message: 'Venta no encontrada' });
        }
        
        res.json({
            status: 'success',
            data: { sale }
        });
    } catch (error) {
        next(error);
    }
};

export const createSale = async (req, res, next) => {
    try {
        const { date, items, notes } = req.body;
        
        // Convertir items a formato correcto
        const normalizedItems = items.map(item => ({
            productId: String(item.productId),
            quantity: parseInt(item.quantity),
            price: parseFloat(item.price)
        }));
        
        // Calcular total y validar stock
        let total = 0;
        for (const item of normalizedItems) {
            const product = await prisma.product.findUnique({
                where: { id: item.productId }
            });
            
            if (!product) {
                return res.status(404).json({ 
                    message: `Producto ${item.productId} no encontrado` 
                });
            }
            
            if (product.stockQuantity < item.quantity) {
                return res.status(400).json({ 
                    message: `Stock insuficiente para ${product.name}. Disponible: ${product.stockQuantity}` 
                });
            }
            
            total += parseFloat(product.price) * item.quantity;
        }
        
        // Crear venta con items y actualizar stock
        const sale = await prisma.$transaction(async (tx) => {
            // Crear venta
            const newSale = await tx.sale.create({
                data: {
                    date: date ? new Date(date) : new Date(),
                    total,
                    notes,
                    items: {
                        create: normalizedItems.map(item => ({
                            productId: item.productId,
                            quantity: item.quantity,
                            price: item.price
                        }))
                    }
                },
                include: {
                    items: {
                        include: {
                            product: true
                        }
                    }
                }
            });
            
            // Actualizar stock de productos
            for (const item of normalizedItems) {
                await tx.product.update({
                    where: { id: item.productId },
                    data: {
                        stockQuantity: {
                            decrement: item.quantity
                        }
                    }
                });
            }
            
            return newSale;
        });
        
        res.status(201).json({
            status: 'success',
            data: { sale }
        });
    } catch (error) {
        next(error);
    }
};

export const deleteSale = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        // Obtener venta con items para restaurar stock
        const sale = await prisma.sale.findUnique({
            where: { id },
            include: { items: true }
        });
        
        if (!sale) {
            return res.status(404).json({ message: 'Venta no encontrada' });
        }
        
        // Eliminar venta y restaurar stock
        await prisma.$transaction(async (tx) => {
            // Restaurar stock
            for (const item of sale.items) {
                await tx.product.update({
                    where: { id: item.productId },
                    data: {
                        stockQuantity: {
                            increment: item.quantity
                        }
                    }
                });
            }
            
            // Eliminar venta (los items se eliminan en cascada)
            await tx.sale.delete({
                where: { id }
            });
        });
        
        res.json({
            status: 'success',
            message: 'Venta eliminada y stock restaurado'
        });
    } catch (error) {
        next(error);
    }
};
