# Attendance & Proxy Management System

A comprehensive Java-based desktop application for managing student attendance and proxy assignments with a modern JavaFX graphical interface.

## Features

### Authentication
- ✅ Role-based login (Admin, Teacher, Student)
- ✅ Secure password hashing using BCrypt
- ✅ User session management

### Admin Features
- ✅ User management (add/remove teachers/students)
- ✅ Dashboard overview with user statistics
- ✅ Database administration
- ✅ System configuration and backup

### Teacher Features
- ✅ Mark attendance for classes (Present, Absent, Late, Excused)
- ✅ View and manage classes
- ✅ Request proxy assignments
- ✅ Generate attendance reports
- ✅ Export reports (PDF/Excel)

### Student Features
- ✅ View personal attendance records
- ✅ Check attendance percentage
- ✅ Receive and manage notifications
- ✅ Download attendance reports
- ✅ Receive proxy assignment notifications

### Database
- ✅ SQLite support (default, no external setup required)
- ✅ MySQL support (optional)
- ✅ Relational database schema with proper foreign keys
- ✅ Automatic database initialization

## Project Structure

```
attendance-proxy-system/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/attendance/
│   │   │       ├── AttendanceSystem.java (main application)
│   │   │       ├── models/
│   │   │       │   ├── User.java
│   │   │       │   ├── Attendance.java
│   │   │       │   ├── Proxy.java
│   │   │       │   └── AttendanceClass.java
│   │   │       ├── ui/
│   │   │       │   ├── AdminDashboard.java
│   │   │       │   ├── TeacherDashboard.java
│   │   │       │   └── StudentDashboard.java
│   │   │       └── utils/
│   │   │           ├── DatabaseConnection.java
│   │   │           └── PasswordUtils.java
│   │   └── resources/
│   │       └── logback.xml (logging configuration)
│   └── test/
└── pom.xml (Maven configuration)
```

## Technologies Used

- **JavaFX**: Modern GUI framework
- **MySQL**: Optional database
- **SQLite**: Default lightweight database
- **BCrypt**: Password hashing
- **Apache PDFBox**: PDF export
- **Apache POI**: Excel export
- **SLF4J + Logback**: Logging framework
- **Maven**: Build and dependency management

## Installation

### Prerequisites
- Java 11 or higher
- Maven 3.6+

### Setup Steps

1. **Clone or extract the project:**
   ```bash
   cd attendance-proxy-system
   ```

2. **Install dependencies:**
   ```bash
   mvn clean install
   ```

3. **Build the project:**
   ```bash
   mvn compile
   ```

## Running the Application

### Method 1: Using Maven
```bash
mvn javafx:run
```

### Method 2: Build and Run JAR
```bash
mvn clean package
java -jar target/attendance-proxy-system-1.0.0.jar
```

### Method 3: IDE (VS Code, IntelliJ, etc.)
- Open the project in your IDE
- Run the `AttendanceSystem` class

## Default Login Credentials

| Role | Username | Password |
|------|----------|----------|
| Admin | admin | admin123 |

**Note:** Change the default admin password after first login.

## Database

### Using SQLite (Default)
The application automatically creates `attendance_system.db` in the project root directory on first run.

### Switching to MySQL
1. Open `src/main/java/com/attendance/utils/DatabaseConnection.java`
2. Change `USE_SQLITE = true` to `USE_SQLITE = false`
3. Update MySQL connection details:
   ```java
   private static final String MYSQL_URL = "jdbc:mysql://localhost:3306/attendance_system";
   private static final String MYSQL_USER = "root";
   private static final String MYSQL_PASSWORD = "your_password";
   ```
4. Create the database in MySQL:
   ```sql
   CREATE DATABASE attendance_system;
   ```

## Database Schema

### Users Table
```sql
CREATE TABLE users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Classes Table
```sql
CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY AUTOINCREMENT,
    subject VARCHAR(100) NOT NULL,
    teacher_id INTEGER NOT NULL,
    schedule VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id)
);
```

### Attendance Table
```sql
CREATE TABLE attendance (
    attendance_id INTEGER PRIMARY KEY AUTOINCREMENT,
    student_id INTEGER NOT NULL,
    class_id INTEGER NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(student_id, class_id, date),
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id)
);
```

### Proxy Table
```sql
CREATE TABLE proxy (
    proxy_id INTEGER PRIMARY KEY AUTOINCREMENT,
    class_id INTEGER NOT NULL,
    original_teacher_id INTEGER NOT NULL,
    proxy_teacher_id INTEGER,
    date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (class_id) REFERENCES classes(class_id),
    FOREIGN KEY (original_teacher_id) REFERENCES users(user_id),
    FOREIGN KEY (proxy_teacher_id) REFERENCES users(user_id)
);
```

### Notifications Table
```sql
CREATE TABLE notifications (
    notification_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    message VARCHAR(255) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

## Features Implementation Status

| Feature | Status | Notes |
|---------|--------|-------|
| Login/Authentication | ✅ Complete | Secure password hashing |
| User Management | ✅ Complete | Admin can add/remove users |
| Mark Attendance | 🔄 In Progress | UI ready, database integration pending |
| View Attendance | ✅ Complete | Students can view records |
| Request Proxy | 🔄 In Progress | UI ready, workflow pending |
| Approve Proxy | 🔄 In Progress | Admin approval workflow |
| Notifications | ✅ Complete | Notification display implemented |
| Reports | 🔄 In Progress | PDF/Excel export pending |
| Charts | 📋 Planned | JavaFX PieChart/BarChart visualization |

## Future Enhancements

- [ ] Integration with email notifications
- [ ] Bulk attendance import from CSV
- [ ] Advanced attendance analytics and charts
- [ ] Class schedule management interface
- [ ] Two-factor authentication
- [ ] Mobile app synchronization
- [ ] Backup and restore functionality
- [ ] User role hierarchy and permissions

## Troubleshooting

### Issue: "JavaFX libraries not found"
**Solution:** Ensure JavaFX is properly configured in POM:
```bash
mvn clean install
```

### Issue: "Database connection error"
**Solution:** 
- For SQLite: Ensure write permissions in project directory
- For MySQL: Verify MySQL is running and credentials are correct

### Issue: "Application won't start"
**Solution:** Check logs in `attendance_system.log` for detailed error messages.

## Logging

All application events are logged to:
- **Console:** Real-time output
- **File:** `attendance_system.log` in project root

Log levels can be configured in `src/main/resources/logback.xml`

## Contributing

To add new features:
1. Create a feature branch
2. Implement changes
3. Test thoroughly
4. Update documentation
5. Submit for review

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or suggestions:
1. Check the troubleshooting section
2. Review logs in `attendance_system.log`
3. Contact the development team

## Version History

### v1.0.0 (Current)
- Initial release
- Core features implemented
- Database schema created
- JavaFX GUI framework

---

**Last Updated:** March 13, 2026
