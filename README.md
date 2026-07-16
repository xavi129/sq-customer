# SQ Customer

Aplicación Flutter para clientes de una plataforma de entregas y servicios: catálogo, carrito, checkout, pagos, seguimiento, chat, farmacia, paquetería y reserva de transporte.

## Contexto del proyecto

Proyecto desarrollado dentro de un equipo. Esta copia de portafolio elimina marcas, datos de producción y credenciales.

Entre los cambios del proyecto se encuentran localización al español, autenticación y OTP por WhatsApp, ajustes de checkout y pagos, integración con Firebase, compatibilidad de iOS y pruebas de widgets.

## Ejecución local

1. Instala Flutter con Dart `>=3.0.6 <4.0.0`.
2. Ejecuta `flutter pub get`.
3. Proporciona tus archivos Firebase locales:
   - `android/app/google-services.json`
   - `ios/GoogleService-Info.plist`
4. Sustituye `YOUR_GOOGLE_MAPS_API_KEY` en Android e iOS.
5. Ejecuta:

```bash
flutter run --dart-define=API_BASE_URL=https://api.example.com
```

## Uso de IA

Este repositorio representa desarrollo Flutter con apoyo de IA. La IA se utilizó como asistente para diagnóstico, generación de pruebas y propuestas de implementación; las decisiones, integración y validación permanecieron bajo responsabilidad humana.

No se presenta como un proyecto individual desarrollado desde cero, sino como trabajo colaborativo y adaptación dentro de un equipo.
