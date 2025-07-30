# 🔒 Security Policy

## 🔐 API Keys and Secrets Management

### **Firebase Configuration**
This project uses Firebase for authentication and data storage. The Firebase API keys in this repository are **public by design** and safe to commit:

- `android/app/google-services.json` - Android Firebase configuration
- `ios/Runner/GoogleService-Info.plist` - iOS Firebase configuration  
- `lib/firebase_options.dart` - Flutter Firebase options

**Why Firebase keys are public:**
- Firebase API keys are designed to be included in client applications
- Security is enforced through Firebase Security Rules, not secret keys
- Keys can be restricted to specific domains/bundle IDs in Firebase Console

### **Third-Party API Keys**
The application uses environment variables for sensitive API keys:

```dart
// Secure pattern used in the codebase
final String? _apiKey = const String.fromEnvironment('FIRECRAWL_API_KEY');
```

**Required environment variables:**
- `FIRECRAWL_API_KEY` - For web content extraction service
- `CONTENT_API_KEY` - For additional content processing (optional)

### **Development Setup**
To run this project locally with full functionality:

1. **Set environment variables:**
   ```bash
   export FIRECRAWL_API_KEY="your_firecrawl_api_key_here"
   export CONTENT_API_KEY="your_content_api_key_here"
   ```

2. **Or create a `.env` file** (ignored by git):
   ```env
   FIRECRAWL_API_KEY=your_firecrawl_api_key_here
   CONTENT_API_KEY=your_content_api_key_here
   ```

3. **Build with environment variables:**
   ```bash
   flutter build apk --dart-define=FIRECRAWL_API_KEY=$FIRECRAWL_API_KEY
   flutter build ios --dart-define=FIRECRAWL_API_KEY=$FIRECRAWL_API_KEY
   ```

### **Production Deployment**
For production builds, set environment variables in your CI/CD pipeline:

- **GitHub Actions**: Use repository secrets
- **Firebase Hosting**: Use Firebase functions configuration
- **App Store/Play Store**: Set during build process

### **Security Best Practices**
✅ **What's secure in this repository:**
- Firebase configuration (public by design)
- Environment variable patterns for sensitive keys
- No hardcoded API keys or secrets
- Proper `.gitignore` for sensitive files

❌ **What to avoid:**
- Never commit actual API keys for third-party services
- Don't store sensitive credentials in source code
- Avoid committing `.env` files with real keys

### **Reporting Security Issues**
If you discover a security vulnerability, please:
1. **Do not** open a public GitHub issue
2. Email the maintainer privately
3. Provide detailed steps to reproduce
4. Allow time for the issue to be addressed

### **Firebase Security Rules**
The application relies on Firebase Security Rules for data protection. Current rules:
- Authenticated users can read/write their own data
- Public read access for article data
- Write access restricted to authenticated users

### **Additional Security Measures**
- **HTTPS only**: All API calls use HTTPS
- **Input validation**: User input is sanitized
- **Error handling**: Sensitive error details not exposed to users
- **Permission management**: Camera/location permissions properly requested

## 📋 Security Checklist for Contributors

Before committing changes:
- [ ] No API keys in source code
- [ ] Environment variables used for secrets
- [ ] `.gitignore` updated for new sensitive files
- [ ] Firebase rules reviewed if data model changes
- [ ] Input validation for new user inputs
- [ ] Error messages don't expose sensitive information

## 🔗 References
- [Firebase Security Documentation](https://firebase.google.com/docs/rules)
- [Flutter Security Best Practices](https://docs.flutter.dev/deployment/android#reviewing-the-app-manifest)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security-testing-guide/)
