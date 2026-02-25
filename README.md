# 🍽️ MoodFood AI Chef

> Toma una foto a tu nevera y recibe una receta personalizada generada por IA.

## ✨ Features
- 📸 Captura ingredientes con la cámara o escríbelos manualmente
- 🤖 Generación de recetas paso a paso con Gemini AI
- 🎨 Imagen generada del plato final
- 💫 Animaciones fluidas con Flutter Animate

## 🛠️ Tech Stack
| Categoría | Tecnología |
|-----------|-----------|
| Framework | Flutter 3.x |
| Estado | Riverpod 2.x |
| Red | Dio |
| Navegación | GoRouter |
| IA | Gemini 2.0 Flash |
| Animaciones | Flutter Animate |

## 🚀 Setup

### 1. Clona el repo
```bash
git clone https://github.com/JuanPCFdev/moodfood_ai.git
cd moodfood_ai
```

### 2. Crea tu archivo `.env`
```bash
cp .env.example .env
# Edita .env y agrega tu Gemini API Key
```

### 3. Instala dependencias
```bash
flutter pub get
```

### 4. Corre la app
```bash
flutter run --dart-define-from-file=.env
```

## 📁 Arquitectura
Clean Architecture con Feature-First organization.
```
lib/
├── core/        # Utilidades globales, red, router
└── features/    # Módulos por funcionalidad
    ├── home/    # Pantalla principal e inputs
    └── recipe/  # Generación y display de recetas
```

## 🔑 API Key
Obtén tu key gratuita en [Google AI Studio](https://aistudio.google.com)

## 📄 Licencia
MIT — Proyecto personal de uso libre.