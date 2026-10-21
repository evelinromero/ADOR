# Activar el inicio de sesión con Google (Firebase)

Mientras no hagas esto, la app funciona en **modo demo**: botones "Entrar como
administrador / usuario" y los datos se guardan solo en el teléfono.

1. Entra a https://console.firebase.google.com y crea un proyecto (plan gratis Spark).
2. **Agregar app → Android**
   - Nombre del paquete: `com.example.mi_app`
   - SHA-1: en una terminal dentro de `android/` ejecuta `./gradlew signingReport`
     y copia el `SHA1` de la variante `debug`.
3. Descarga `google-services.json` y ponlo en `android/app/google-services.json`.
4. **Authentication → Método de acceso → Google → Habilitar**.
5. **Firestore Database → Crear base de datos** (modo producción) y en la pestaña
   **Reglas** pega el contenido de `firestore.rules`.
6. Vuelve a compilar: `flutter run`.

Ahora aparece "Continuar con Google". Las cuentas en `lib/config.dart`
(`adminEmails`) entran como administrador; las demás como usuario.
Si agregas otro admin, agrégalo también en `firestore.rules`.

Notas:
- Las imágenes se comprimen y se guardan dentro de Firestore, así que no
  necesitas Firebase Storage (que exige plan de pago).
- El audio se reproduce desde un enlace directo a mp3, o se abre el enlace de
  YouTube/Spotify.
- Los mapas usan OpenStreetMap: no necesitan API key.
