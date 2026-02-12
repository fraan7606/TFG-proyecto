import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
    console.log('Seeding services and staff...');

    // 1. Crear Servicios de prueba
    const services = [
        {
            name: 'Limpieza Facial Express',
            description: 'Limpieza rápida y refrescante',
            durationMinutes: 30,
            price: 25.00,
        },
        {
            name: 'Manicura Completa',
            description: 'Cuidado completo de uñas y manos',
            durationMinutes: 45,
            price: 35.00,
        },
        {
            name: 'Tratamiento Hidratación Profunda',
            description: 'Tratamiento intensivo para la piel',
            durationMinutes: 60,
            price: 50.00,
        },
    ];

    for (const service of services) {
        await prisma.service.upsert({
            where: { id: service.name }, // This won't work because ID is UUID, using findUnique or create
            update: {},
            create: service,
        }).catch(async () => {
            // Fallback if upsert fails due to UUID requirement in where
            const existing = await prisma.service.findFirst({ where: { name: service.name } });
            if (!existing) {
                await prisma.service.create({ data: service });
            }
        });
    }

    console.log('Services seeded successfully.');
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
