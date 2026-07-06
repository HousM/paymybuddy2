# CLAUDE.md

Guidance for AI assistants working in this repository.

## Project

**Pay My Buddy** — a Spring Boot MVC prototype for a peer-to-peer money-transfer web app (OpenClassrooms training project). Server-side rendered with JSP + JSTL, backed by MySQL via Spring Data JPA, secured with Spring Security form login.

The codebase is an early prototype: several UI links point to controllers/entities that do not exist yet (see "Known Gaps" below). Do not assume a feature is implemented just because the JSP references it.

## Stack

- **Java 11**, Maven (use the wrapper `./mvnw`)
- **Spring Boot 2.5.6** parent, with several dependencies pinned to **2.6.1** (`spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `spring-boot-starter-test`) — mixing versions is inherited from the original project; keep it consistent when adding deps unless deliberately upgrading
- **Spring Security 5.5.2** (form login, BCrypt), `spring-boot-starter-oauth2-client` present but unused
- **JSP + JSTL 1.2**, `tomcat-embed-jasper` 9.0.44 (packaged as a `SpringBootServletInitializer` so it can also deploy to an external Tomcat)
- **MySQL** via `mysql-connector-java`, Hibernate MySQL5Dialect
- **JUnit 5** via `spring-boot-starter-test` + `spring-security-test`

## Layout

```
src/main/java/com/openclassrooms/paymybuddy/
  PaymybuddyApplication.java        # @SpringBootApplication, extends SpringBootServletInitializer
  configuration/SpringSecurityConfig.java
  controller/UserController.java    # all HTTP endpoints live here
  service/UserService.java          # implements UserDetailsService
  repository/UserRepository.java    # CrudRepository<User, Integer>
  model/
    User.java                       # implements UserDetails; @Table("user")
    Connect.java                    # role-ish entity; @Table("connect")

src/main/resources/
  application.properties            # MySQL DSN + JSP view resolver
  static/                           # bootstrap.min.css, per-page CSS, PNG icons served at /
src/main/webapp/WEB-INF/
  login.jsp  register.jsp  profil.jsp  transfer.jsp   # views resolved via prefix/suffix

src/test/java/.../PaymybuddyApplicationTests.java     # only a contextLoads smoke test
```

**Package note.** Maven `groupId` is `com.paymybuddy` but the Java package is `com.openclassrooms.paymybuddy`. Keep new code under `com.openclassrooms.paymybuddy` — that's what `@SpringBootApplication` scans.

## Data model

- `User` (`user` table): `user_id` PK, `firstname`, `lastname`, `email` (used as Spring Security username), `password` (BCrypt hash), `balance` (float, defaults to 1000 on registration).
  - `@OneToOne` → `Connect` via `role_id` join column — note the join column name doesn't match `Connect.connectId` (`connect_id`); the SQL schema likely aliases them.
  - `@OneToMany(FetchType.EAGER, CascadeType.ALL, orphanRemoval)` self-relation via join table `user_buddy(user_id, user_id_buddy)` for the buddy list.
- `Connect` (`connect` table): `connect_id`, `libelle`. Registration hard-codes `connectId=2` for new users (`UserService.saveUser`).
- No JPA schema generation is configured — the MySQL schema is expected to exist externally. There is no `schema.sql`/`data.sql` in the repo.

## Endpoints (UserController)

| Method | Path            | Notes |
|--------|-----------------|-------|
| GET    | `/login`        | renders `login.jsp`, permitAll |
| POST   | `/login`        | Spring Security processing URL (form params `email`/`password`) |
| GET    | `/register`     | renders `register.jsp`, permitAll |
| POST   | `/newuser`      | creates user, redirects to `/transfer` |
| GET    | `/profil`       | requires auth; puts current `User` in model as `userDetails` |
| GET    | `/newbuddy`     | renders `newbuddy` view (⚠ JSP not present) |
| POST   | `/addbuddy`     | adds a buddy by email to the logged-in user's `userBuddy` list |
| GET    | `/deletebuddy`  | renders `deletebuddy` view (⚠ JSP not present) |
| POST   | `/deletebuddy`  | removes a buddy by email |
| —      | `/transfer`     | referenced as `defaultSuccessUrl` and by JSPs, but no `@GetMapping("/transfer")` exists (⚠) |

## Security config (`SpringSecurityConfig`)

- CSRF disabled globally.
- Public: `/login`, `/register`, `/resources/**`.
- Authenticated: `/profil/**`, `/transfer/**`.
- Everything else is currently unrestricted by explicit rule — mind this when adding endpoints.
- Form login: `usernameParameter="email"`, `passwordParameter="password"`, success → `/transfer`, failure → `/login?error=true`.
- Logout: URL `/logout`, deletes `JSESSIONID`, redirect `/login`.
- `httpBasic()` is also enabled.
- `UserService` implements `UserDetailsService`; `User` implements `UserDetails` directly (`getUsername()` returns email, `getAuthorities()` returns `null` — treat as no roles).

## Configuration

`src/main/resources/application.properties` currently hard-codes a local MySQL DSN:
```
spring.datasource.url=jdbc:mysql://localhost:3306/paymybuddy?serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=root
```
There is no profile-based override. When running elsewhere, either edit this file (don't commit real secrets) or pass `-Dspring.datasource.*` / env vars via `SPRING_DATASOURCE_*`.

JSP view resolver: `spring.mvc.view.prefix=/WEB-INF/`, `spring.mvc.view.suffix=.jsp`. Controllers return logical names like `"login"` → `/WEB-INF/login.jsp`.

## Build & run

```bash
./mvnw clean package         # builds jar in target/
./mvnw spring-boot:run       # runs against the configured MySQL
./mvnw test                  # runs JUnit tests (needs Spring context; MySQL must be reachable
                             # for @SpringBootTest to boot — override datasource for CI)
```

The app extends `SpringBootServletInitializer`, so the jar is also deployable as a WAR-style container app if repackaged; the current `pom.xml` produces a jar (no `<packaging>war</packaging>`).

## Testing

Only `PaymybuddyApplicationTests.contextLoads()` exists. It uses `@SpringBootTest`, which loads the full context — including the MySQL datasource. To run it without a live MySQL, add an H2 profile or an in-memory `@TestConfiguration`. Add real tests under `src/test/java/com/openclassrooms/paymybuddy/**` mirroring the main package layout.

## Conventions

- **Language:** most identifiers are English, some French leaked in (e.g. `Connect.libelle`, `entete` in JSPs, `profil` route). Match the surrounding file rather than normalizing on sight.
- **Constructors:** services/controllers keep both a no-arg constructor and an autowired constructor. `@Autowired` is on the field, not the constructor — don't refactor to constructor injection without a reason.
- **Persistence:** `@DynamicUpdate` on entities. Use `CrudRepository` derived queries (`findByEmail`, `findByFirstname`) rather than JPQL unless needed.
- **Passwords:** always BCrypt via the `PasswordEncoder` bean. `UserService.saveUser` currently news up its own `BCryptPasswordEncoder` — prefer the injected bean when adding new save paths.
- **Views:** logical view names map directly to `/WEB-INF/<name>.jsp`. CSS/PNG assets live in `src/main/resources/static/` and are served from `/`.

## Known gaps (do not "fix" silently — flag or scope with the user)

- No `/transfer` GET handler despite being the post-login landing page and being linked from every JSP.
- No `Transfer` entity, repository, or `/newtransfer`, `/banktransfer` endpoints, though `transfer.jsp` iterates `${transfer}` and posts to `/newtransfer`.
- No `newbuddy.jsp` / `deletebuddy.jsp` (the GET handlers reference these view names).
- `/contact` link in JSPs has no controller.
- `User.getAuthorities()` returns `null` — Spring Security tolerates this for form login here, but any `hasRole/hasAuthority` check will NPE.
- `Connect` has no setter for `libelle` and no `@JoinColumn` sanity between `role_id` and `connect_id`.
- `application.properties` contains plaintext DB credentials — don't add real ones.

## Working in this repo

- Development branch for AI-assisted changes: **`claude/claude-md-docs-hdqzp6`** (per session instructions). Commit and push there; do not push to `master`.
- Match the existing style (field injection, tabs/spaces as found in the file being edited — some files use tabs, others 4-space indent).
- When adding a controller endpoint, remember to also add it to the security rules in `SpringSecurityConfig.configure(HttpSecurity)` if it needs auth or should be public.
