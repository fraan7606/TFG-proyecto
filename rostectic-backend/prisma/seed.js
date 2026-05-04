import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
    console.log('Seeding services, staff, users, and appointments...');

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

    const createdServices = [];
    for (const service of services) {
        const existing = await prisma.service.findFirst({ where: { name: service.name } });
        if (!existing) {
            const created = await prisma.service.create({ data: service });
            createdServices.push(created);
        } else {
            createdServices.push(existing);
        }
    }

    console.log('Services seeded successfully.');

    // 2. Crear Especialista
    let specialist = await prisma.specialist.findFirst({ where: { name: 'Rosana' } });
    if (!specialist) {
        specialist = await prisma.specialist.create({
            data: {
                name: 'Rosana',
                role: 'Esteticista',
                active: true,
            },
        });
    }

    console.log('Specialists seeded successfully.');

    // 3. Crear Usuarios de prueba
    const hashedPassword = await bcrypt.hash('Demo123!', 10);
    const hashedAdminPassword = await bcrypt.hash('Admin123!', 10);

    let demoUser = await prisma.user.findFirst({ where: { email: 'demo@rostectic.com' } });
    if (!demoUser) {
        demoUser = await prisma.user.create({
            data: {
                name: 'Demo Cliente',
                email: 'demo@rostectic.com',
                phone: '+34612345678',
                passwordHash: hashedPassword,
                authMethod: 'EMAIL',
                role: 'CLIENT',
            },
        });
    }

    let demo2User = await prisma.user.findFirst({ where: { email: 'demo2@rostectic.com' } });
    if (!demo2User) {
        demo2User = await prisma.user.create({
            data: {
                name: 'Demo Usuario 2',
                email: 'demo2@rostectic.com',
                phone: '+34612345679',
                passwordHash: hashedPassword,
                authMethod: 'EMAIL',
                role: 'CLIENT',
            },
        });
    }

    let adminUser = await prisma.user.findFirst({ where: { email: 'admin@rostectic.com' } });
    if (!adminUser) {
        adminUser = await prisma.user.create({
            data: {
                name: 'Admin RosTectic',
                email: 'admin@rostectic.com',
                phone: '+34612345600',
                passwordHash: hashedAdminPassword,
                authMethod: 'EMAIL',
                role: 'ADMIN',
            },
        });
    }

    console.log('Users seeded successfully.');

    // 4. Crear Citas de prueba (futuras y pasadas)
    const now = new Date();

    // Cita futura para mañana
    const tomorrow = new Date(now);
    tomorrow.setDate(tomorrow.getDate() + 1);
    tomorrow.setHours(10, 0, 0, 0);

    let futureAppointment = await prisma.appointment.findFirst({
        where: {
            userId: demoUser.id,
            serviceId: createdServices[0].id,
            scheduledAt: tomorrow,
        },
    });
    if (!futureAppointment) {
        futureAppointment = await prisma.appointment.create({
            data: {
                userId: demoUser.id,
                serviceId: createdServices[0].id,
                specialistId: specialist.id,
                scheduledAt: tomorrow,
                status: 'CONFIRMED',
                notes: 'Especialista: Rosana',
            },
        });
    }

    // Cita futura en 3 días
    const in3Days = new Date(now);
    in3Days.setDate(in3Days.getDate() + 3);
    in3Days.setHours(14, 30, 0, 0);

    let futureAppointment2 = await prisma.appointment.findFirst({
        where: {
            userId: demoUser.id,
            serviceId: createdServices[1].id,
            scheduledAt: in3Days,
        },
    });
    if (!futureAppointment2) {
        futureAppointment2 = await prisma.appointment.create({
            data: {
                userId: demoUser.id,
                serviceId: createdServices[1].id,
                specialistId: specialist.id,
                scheduledAt: in3Days,
                status: 'PENDING',
                notes: 'Especialista: Rosana',
            },
        });
    }

    // Cita pasada (completada)
    const yesterday = new Date(now);
    yesterday.setDate(yesterday.getDate() - 1);
    yesterday.setHours(11, 0, 0, 0);

    let pastAppointment = await prisma.appointment.findFirst({
        where: {
            userId: demoUser.id,
            serviceId: createdServices[2].id,
            scheduledAt: yesterday,
        },
    });
    if (!pastAppointment) {
        pastAppointment = await prisma.appointment.create({
            data: {
                userId: demoUser.id,
                serviceId: createdServices[2].id,
                specialistId: specialist.id,
                scheduledAt: yesterday,
                status: 'COMPLETED',
                notes: 'Especialista: Rosana',
            },
        });
    }

    // Cita para usuario 2
    const tomorrowAlt = new Date(now);
    tomorrowAlt.setDate(tomorrowAlt.getDate() + 1);
    tomorrowAlt.setHours(15, 0, 0, 0);

    let demo2Appointment = await prisma.appointment.findFirst({
        where: {
            userId: demo2User.id,
            serviceId: createdServices[1].id,
            scheduledAt: tomorrowAlt,
        },
    });
    if (!demo2Appointment) {
        demo2Appointment = await prisma.appointment.create({
            data: {
                userId: demo2User.id,
                serviceId: createdServices[1].id,
                specialistId: specialist.id,
                scheduledAt: tomorrowAlt,
                status: 'CONFIRMED',
                notes: 'Especialista: Rosana',
            },
        });
    }

    console.log('Appointments seeded successfully.');
    console.log('\n✅ Seed completed!');
    console.log('\nTest Credentials:');
    console.log('👤 Cliente 1: demo@rostectic.com / Demo123!');
    console.log('👤 Cliente 2: demo2@rostectic.com / Demo123!');
    console.log('👨‍💼 Admin: admin@rostectic.com / Admin123!');
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
