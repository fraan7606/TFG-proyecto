import { PrismaClient } from '@prisma/client';
const prisma = new PrismaClient();

async function main() {
    const rosana = await prisma.specialist.upsert({
        where: { id: 'rosana-id-1' }, // ID fijo para el seed
        update: {},
        create: {
            id: 'rosana-id-1',
            name: 'Rosana',
            role: 'Esteticista',
        },
    });

    console.log('Seed Specialist: Rosana created/updated');
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
