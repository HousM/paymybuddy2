# CLAUDE.md — Pay My Buddy

## Contexte du projet
Application web Spring Boot (projet de formation OpenClassrooms) de transfert d'argent entre amis. Rendu côté serveur en JSP + JSTL, persistance MySQL via Spring Data JPA, authentification par formulaire Spring Security.

**Le dépôt est un prototype précoce.** Plusieurs liens JSP pointent vers des contrôleurs ou entités qui n'existent pas encore (voir §« Écarts connus »). Ne jamais supposer qu'une fonctionnalité est implémentée sur la seule foi d'un lien JSP : vérifier dans `UserController` et dans les modèles avant d'ajouter du code qui en dépend.

## Règles non négociables
- Mots de passe **toujours** hachés en BCrypt via le bean `PasswordEncoder`. Ne jamais instancier un nouvel encodeur ad hoc (le code existant dans `UserService.saveUser` le fait — ne pas propager ce pattern).
- Toute route ajoutée doit être classée explicitement dans `SpringSecurityConfig.configure(HttpSecurity)` : `permitAll()` si publique, `authenticated()` sinon. Ne pas laisser une route sensible tomber dans le comportement par défaut.
- Aucun secret en dur dans le dépôt (le `application.properties` actuel contient des identifiants MySQL de démo `root/root` — ne pas y écrire de vraies valeurs, préférer les variables d'environnement `SPRING_DATASOURCE_*`).
- CSRF est désactivé globalement dans la config actuelle : en tenir compte avant d'exposer une nouvelle route mutante, et ne pas s'appuyer sur une protection CSRF absente.
- Le package Java scanné est `com.openclassrooms.paymybuddy` (bien que le `groupId` Maven soit `com.paymybuddy`). Tout nouveau code doit rester sous ce package sinon il ne sera pas découvert par `@SpringBootApplication`.

## Stack imposée
- **Java 11**, Maven via le wrapper (`./mvnw`).
- **Spring Boot 2.5.6** parent, avec `spring-boot-starter-web`, `-data-jpa`, `-test` **épinglés en 2.6.1** (héritage du projet initial — garder cette cohérence sauf montée de version délibérée).
- **Spring Security 5.5.2** (form login, BCrypt). `spring-boot-starter-oauth2-client` présent mais non utilisé.
- **JSP + JSTL 1.2**, `tomcat-embed-jasper 9.0.44`. L'application étend `SpringBootServletInitializer` (déployable en WAR sur un Tomcat externe si repackagée).
- **MySQL** via `mysql-connector-java`, dialecte `MySQL5Dialect`.
- **JUnit 5** via `spring-boot-starter-test` + `spring-security-test`.
- Pas d'ORM ou de starter supplémentaire sans justification.

## Architecture
```
src/main/java/com/openclassrooms/paymybuddy/
  PaymybuddyApplication.java        # @SpringBootApplication + SpringBootServletInitializer
  configuration/
    SpringSecurityConfig.java       # règles HTTP, DaoAuthenticationProvider, BCrypt
  controller/
    UserController.java             # toutes les routes HTTP
  service/
    UserService.java                # implémente UserDetailsService
  repository/
    UserRepository.java             # CrudRepository<User, Integer>
  model/
    User.java                       # implémente UserDetails ; @Table("user")
    Connect.java                    # entité "rôle" ; @Table("connect")

src/main/resources/
  application.properties            # DSN MySQL + resolver JSP
  static/                           # bootstrap.min.css, CSS par page, PNG servis à la racine

src/main/webapp/WEB-INF/
  login.jsp  register.jsp  profil.jsp  transfer.jsp

src/test/java/.../PaymybuddyApplicationTests.java   # unique test : contextLoads
```

## Modèle de données
- **`User`** (table `user`) : `user_id` PK, `firstname`, `lastname`, `email` (utilisé comme `username` Spring Security), `password` (hash BCrypt), `balance` (float, initialisé à 1000 à l'inscription).
  - `@OneToOne` → `Connect` via `role_id` (le nom de colonne diffère de `connect_id` côté `Connect` ; le schéma SQL réel est supposé aligner les deux).
  - Auto-relation `@OneToMany(EAGER, CascadeType.ALL, orphanRemoval)` via table de jonction `user_buddy(user_id, user_id_buddy)` pour la liste d'amis.
- **`Connect`** (table `connect`) : `connect_id`, `libelle`. À l'inscription, `UserService.saveUser` force `connectId = 2` (rôle utilisateur standard).
- **Aucune génération de schéma JPA** n'est configurée : le schéma MySQL doit exister en amont. Aucun `schema.sql` / `data.sql` dans le dépôt.

## Sécurité (`SpringSecurityConfig`)
- CSRF désactivé (`.csrf().disable()`).
- Public : `/login`, `/register`, `/resources/**`.
- Authentifié : `/profil/**`, `/transfer/**`.
- Le reste n'a **pas** de règle explicite — attention lors de l'ajout d'endpoints.
- Form login : `usernameParameter="email"`, `passwordParameter="password"`, succès → `/transfer`, échec → `/login?error=true`.
- Logout : URL `/logout`, suppression du cookie `JSESSIONID`, redirection `/login`.
- `httpBasic()` activé également.
- `UserService implements UserDetailsService` ; `User implements UserDetails` (`getUsername()` renvoie l'email, `getAuthorities()` renvoie **`null`** — tout `hasRole()`/`hasAuthority()` produirait une NPE).

## Routes existantes (`UserController`)
| Méthode | Chemin          | Notes |
|---------|-----------------|-------|
| GET     | `/login`        | Rend `login.jsp`, permitAll |
| POST    | `/login`        | Traité par Spring Security |
| GET     | `/register`     | Rend `register.jsp`, permitAll |
| POST    | `/newuser`      | Crée l'utilisateur, redirige vers `/transfer` |
| GET     | `/profil`       | Auth requise ; injecte `User` courant sous la clé `userDetails` |
| GET     | `/newbuddy`     | Rend la vue `newbuddy` (⚠ JSP absent) |
| POST    | `/addbuddy`     | Ajoute un ami par email à la liste `userBuddy` |
| GET     | `/deletebuddy`  | Rend la vue `deletebuddy` (⚠ JSP absent) |
| POST    | `/deletebuddy`  | Retire un ami par email |
| —       | `/transfer`     | **Aucun `@GetMapping` associé** malgré son rôle de landing post-login et sa présence dans les JSP (⚠) |

## Configuration
`src/main/resources/application.properties` fixe une DSN MySQL locale :
```
spring.datasource.url=jdbc:mysql://localhost:3306/paymybuddy?serverTimezone=UTC
spring.datasource.username=root
spring.datasource.password=root
```
Aucun profil (`application-{profile}.properties`) n'est défini. Pour un autre environnement : surcharger via variables d'environnement `SPRING_DATASOURCE_*` ou via `-D` en ligne de commande.

Resolver JSP : `spring.mvc.view.prefix=/WEB-INF/`, `spring.mvc.view.suffix=.jsp`. Les contrôleurs renvoient un nom logique (`"login"` → `/WEB-INF/login.jsp`).

## Charte graphique (existante, à respecter)
- Bootstrap (`bootstrap.min.css` servi depuis `static/`) + une feuille CSS par écran (`login.css`, `register.css`, `profil.css`, `transfer.css`).
- Icônes PNG (`email.png`, `pwd.png`) référencées en `background-image` inline dans les JSP.
- Structure JSP : `<header id="entete">` avec liens de navigation (Home / Transfert / Profil / Contact / Logout), puis `<body>` avec le contenu.
- Mélange français/anglais dans l'UI (`Transfert`, `Profil`, `Connections`) — reproduire le ton du fichier modifié plutôt que d'uniformiser à la volée.

## Conventions de code
- **Injection** : par champ (`@Autowired` sur le champ) ; les services/contrôleurs conservent un constructeur vide **et** un constructeur autowired. Ne pas migrer vers l'injection par constructeur sans raison explicite.
- **Entités JPA** : `@DynamicUpdate` conservé. Utiliser les dérivations `CrudRepository` (`findByEmail`, etc.) plutôt que JPQL sauf nécessité.
- **Vues** : nom logique = nom de fichier JSP dans `/WEB-INF/`. Assets statiques (`css`, `png`) servis depuis la racine.
- **Un contrôleur = un fichier**. Aujourd'hui tout est concentré dans `UserController` — si une entité `Transfer` apparaît, créer `TransferController` plutôt que d'étendre celui-ci.
- **Langue** : identifiants majoritairement en anglais, quelques mots français persistants (`Connect.libelle`, `entete`, `profil`). Aligner avec le fichier modifié, ne pas normaliser d'office.
- Toute nouvelle route : ajouter la règle de sécurité correspondante dans `SpringSecurityConfig` **dans le même commit**.
- `./mvnw test` doit passer avant chaque commit (attention : `contextLoads` charge le contexte complet et exige une DSN atteignable — voir §Tests).

## Build & exécution
```bash
./mvnw clean package          # produit target/PayMyBuddy-0.0.1-SNAPSHOT.jar
./mvnw spring-boot:run        # lance sur la MySQL configurée
./mvnw test                   # exécute les tests JUnit
```

## Tests
- Seul `PaymybuddyApplicationTests.contextLoads()` existe. Il utilise `@SpringBootTest` et charge donc l'intégralité du contexte, y compris la datasource MySQL. Pour le rendre exécutable sans MySQL vivant : ajouter un profil H2 ou une `@TestConfiguration` in-memory dédiée aux tests.
- Nouveaux tests obligatoires pour :
  - Toute logique de calcul sur `balance` (dès que la fonctionnalité `/transfer` sera codée).
  - Tout parseur d'entrée utilisateur (montants, emails).
  - Les branches de sécurité ajoutées à `SpringSecurityConfig` (via `spring-security-test`).
- Arborescence miroir : `src/test/java/com/openclassrooms/paymybuddy/**`.

## Écarts connus (ne pas « corriger » silencieusement)
Ces manques sont à traiter comme des tickets à ouvrir, pas à combler en passant :
1. Pas de `@GetMapping("/transfer")` — la page cible du login n'a pas de handler.
2. Pas d'entité `Transfer`, pas de `TransferRepository`, pas d'endpoints `/newtransfer` ni `/banktransfer`, alors que `transfer.jsp` itère `${transfer}` et poste sur `/newtransfer`.
3. Vues `newbuddy.jsp` et `deletebuddy.jsp` absentes (les `@GetMapping` renvoient ces noms logiques).
4. Lien `/contact` présent dans toutes les JSP sans contrôleur associé.
5. `User.getAuthorities()` renvoie `null` — tolérable pour le form login actuel, mais toute vérification de rôle plantera.
6. `Connect` : pas de setter pour `libelle`, incohérence apparente entre `role_id` (côté `User`) et `connect_id` (côté `Connect`).
7. `application.properties` en clair avec `root/root` — remplacer par des variables d'environnement avant tout déploiement réel.

## Plan de développement suggéré (respecter l'ordre)
1. **Socle sécurité** : profil de test H2, ajouter les tests d'intégration Spring Security, corriger `getAuthorities()`.
2. **Route `/transfer`** : `@GetMapping("/transfer")` qui charge l'utilisateur courant, ses `userBuddy` et une liste `transfer` vide (préparer le modèle attendu par la JSP).
3. **Entité `Transfer`** : `sender`, `receiver`, `amount`, `description`, `date` ; `TransferRepository` ; `TransferService` (débit/crédit atomiques sur `balance`).
4. **Endpoints transfert** : `POST /newtransfer` (validation montant > 0, solde suffisant, ami existant), `GET/POST /banktransfer` (recharge/retrait).
5. **Vues manquantes** : `newbuddy.jsp`, `deletebuddy.jsp`, page `/contact`.
6. **Durcissement** : réactiver CSRF (adapter les JSP avec le token JSTL), passer les identifiants MySQL en env vars, ajouter des tests sur `UserService.addBuddy/deleteBuddy` (cas ami inexistant, ami déjà présent, ami = soi-même).
7. **Finitions** : rôles réels dans `getAuthorities()`, message d'erreur i18n, cohérence français/anglais dans l'UI.

En fin de chaque étape : `./mvnw test` doit passer et les règles de sécurité doivent couvrir toutes les nouvelles routes.

## Definition of Done
Une évolution n'est considérée terminée que si :
1. `./mvnw clean test` passe.
2. Toute nouvelle route est déclarée dans `SpringSecurityConfig`.
3. Aucune donnée sensible (mot de passe, DSN prod) n'est présente dans le diff.
4. Les mots de passe éventuels sont hachés via le bean `PasswordEncoder` injecté (pas d'instanciation locale).
5. Les vues JSP référencées par les contrôleurs existent réellement dans `/WEB-INF/`.
6. Un test couvre au minimum le chemin nominal de la nouvelle logique métier.
7. Le fichier `CLAUDE.md` est mis à jour si l'architecture, les conventions ou les écarts connus évoluent.

## Travail sur ce dépôt
- Branche de développement pour les changements assistés par IA : **`claude/claude-md-docs-hdqzp6`**. Commit et push sur cette branche uniquement — jamais sur `master` sans autorisation explicite.
- Style : respecter l'indentation du fichier modifié (certains fichiers utilisent des tabulations, d'autres 4 espaces).
- Messages de commit : concis, en français ou en anglais selon le contexte du diff, décrivant le **pourquoi** et non le **quoi**.
