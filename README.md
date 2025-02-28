# Flutter Todo List App

A modern todo list application built with Flutter and Supabase, featuring real-time updates and user authentication.

## Features

- User authentication (signup, login, email verification)
- Create, read, update, and delete todo items
- Real-time updates when todos change
- Priority levels for todos
- Due dates for todos
- Responsive design for web and mobile

## Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- A Supabase account and project

## Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd to_do_list
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create a `.env` file in the root directory (copy from `.env.example`):
```bash
cp .env.example .env
```

4. Update the `.env` file with your Supabase credentials:
```
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

5. Run the app:
```bash
flutter run
```

## Deployment to Render

1. Create a new Static Site on Render
2. Connect your GitHub repository
3. Configure the following settings:
   - Build Command: `flutter build web --release`
   - Publish Directory: `build/web`
4. Add environment variables:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
5. Deploy!

## Development

- To run in debug mode:
```bash
flutter run
```

- To build for web:
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── models/         # Data models
├── screens/        # UI screens
├── services/       # Business logic and API calls
└── widgets/        # Reusable UI components
```

## Contributing

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
# cursor-to-do-list
