import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: 'resources/js/app.js',
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],

    // Pełna konfiguracja pod środowisko Docker
    server: {
        host: '0.0.0.0',     // Pozwala na dostęp spoza kontenera
        port: 5173,          // Standardowy port Vite
        strictPort: true,    // Jeśli port 5173 jest zajęty, Vite wyrzuci błąd zamiast szukać innego
        hmr: {
            host: 'localhost', // Adres, pod którym przeglądarka szuka serwera HMR
        },
        watch: {
            // Kluczowe dla Dockera: wymusza sprawdzanie zmian w plikach
            usePolling: true,
            interval: 100,
        },
    },
});