import { spawn } from 'child_process';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

console.log('🚀 Iniciando RosTectic Backend...');

// Iniciar el servidor
const server = spawn('node', ['src/server.js'], {
    cwd: __dirname,
    stdio: 'inherit',
    shell: true
});

server.on('error', (err) => {
    console.error('❌ Error al iniciar el servidor:', err);
    process.exit(1);
});

server.on('close', (code) => {
    console.log(`Servidor cerrado con código ${code}`);
    process.exit(code);
});

// Manejar señales de cierre
process.on('SIGINT', () => {
    console.log('\n🛑 Cerrando servidor...');
    server.kill();
    process.exit(0);
});
