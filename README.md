# Smart Health Appointment and Patient Management System

A full JSP + Servlets + MySQL MVC web application implementing:
- Patient registration and login
- Appointment booking
- Appointment history with cancel/reschedule
- Personal detail update
- Admin appointment approve/reject flow
- Admin patient record CRUD
- Admin doctor schedule management
- Admin system user management
- Basic operational reports

## Tech Stack
- Frontend: JSP, CSS
- Backend: Java (Jakarta Servlets)
- Database: MySQL
- Architecture: MVC

## Project Structure
- `src/main/java/com/smarthealth/model` - Model classes
- `src/main/java/com/smarthealth/dao` - Database access (DAO)
- `src/main/java/com/smarthealth/controller` - Servlets/controllers
- `src/main/webapp/WEB-INF/views` - JSP views
- `src/main/webapp/assets/css` - UI stylesheet
- `src/main/resources/sql/schema.sql` - DB schema and seed data

## Database Setup
1. Create MySQL database and tables using `src/main/resources/sql/schema.sql`.
2. Default seeded admin account:
   - Email: `admin@smarthealth.com`
   - Password: `admin`
3. Update DB connection values using environment variables if needed:
   - `SMART_HEALTH_DB_URL`
   - `SMART_HEALTH_DB_USER`
   - `SMART_HEALTH_DB_PASS`

If env vars are not set, defaults are:
- URL: `jdbc:mysql://localhost:3306/smart_healthcare?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC`
- User: `root`
- Password: `root`

## Build and Run
1. Ensure Java 17+, Maven, and MySQL are installed.
2. Build WAR:
   - `mvn clean package`
3. Deploy `target/smart-healthcare.war` to a Jakarta-compatible servlet container (for example Tomcat 10+).
4. Open:
   - `http://localhost:8080/smart-healthcare/login`

## Notes
- Passwords are hashed with SHA-256.
- Servlets are annotation-mapped (`@WebServlet`).
- JSP pages are kept under `WEB-INF/views` to prevent direct URL access.
