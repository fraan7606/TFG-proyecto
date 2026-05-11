import prisma from '../config/database.js';

export const getProducts = async (req, res, next) => {
    try {
        const products = await prisma.product.findMany({
            orderBy: { name: 'asc' }
        });
        res.json({
            status: 'success',
            data: { products }
        });
    } catch (error) {
        next(error);
    }
};

export const getProductById = async (req, res, next) => {
    try {
        const { id } = req.params;
        const product = await prisma.product.findUnique({
            where: { id }
        });
        if (!product) {
            return res.status(404).json({ message: 'Producto no encontrado' });
        }
        res.json({
            status: 'success',
            data: { product }
        });
    } catch (error) {
        next(error);
    }
};

export const createProduct = async (req, res, next) => {
    try {
        const { name, description, stockQuantity, price, minStockAlert } = req.body;
        
        const data = {
            name,
            description,
            stockQuantity: parseInt(stockQuantity),
            price: parseFloat(price)
        };
        
        // Solo agregar minStockAlert si está presente
        if (minStockAlert !== undefined && minStockAlert !== null) {
            data.minStockAlert = parseInt(minStockAlert);
        }
        
        const product = await prisma.product.create({ data });
        
        res.status(201).json({
            status: 'success',
            data: { product }
        });
    } catch (error) {
        next(error);
    }
};

export const updateProduct = async (req, res, next) => {
    try {
        const { id } = req.params;
        const { name, description, stockQuantity, price, minStockAlert } = req.body;
        
        const data = {};
        if (name !== undefined) data.name = name;
        if (description !== undefined) data.description = description;
        if (stockQuantity !== undefined) data.stockQuantity = parseInt(stockQuantity);
        if (price !== undefined) data.price = parseFloat(price);
        if (minStockAlert !== undefined && minStockAlert !== null) {
            data.minStockAlert = parseInt(minStockAlert);
        }
        
        const product = await prisma.product.update({
            where: { id },
            data
        });
        
        res.json({
            status: 'success',
            data: { product }
        });
    } catch (error) {
        next(error);
    }
};

export const deleteProduct = async (req, res, next) => {
    try {
        const { id } = req.params;
        
        await prisma.product.delete({
            where: { id }
        });
        
        res.json({
            status: 'success',
            message: 'Producto eliminado correctamente'
        });
    } catch (error) {
        next(error);
    }
};
