# __MICROS_TEMPLATE__ – Quarkus Hexagonal Microservice Template

Template for build microservice with hexagonal architecture based on Quarkus framework

The idea was:

- Use this template for create a new repo on gh,
- give a new name to the project
- **useing always the same structure** (domain -> application -> adapters -> boot),
- launch script (`init-micros.sh`) to personalize your micro (possibly using the name of the project as `__MICROS_TEMPLATE__` name),
- already have a little working flow (`/api/v1/greetings`).

---

## Requirements

- JDK **21+** (atm)
- Maven (using 3.9.11 `mvnw` atm)
- Any shell supporting `bash`

---

## Project structure 

After init, the structure will be:

```text
<project-name>
├─ pom.xml                          # parent POM (packaging=pom)
├─ <project-name>-domain            # domain (business logic isolated)
├─ <project-name>-application       # use case + ports 
├─ <project-name>-inbound-adapter   # REST API, consumer
├─ <project-name>-outbound-adapter  # DB, client, producer
└─ <project-name>-boot              # modulo runtime Quarkus

dependecy schemas:

boot ──┬──> inbound-adapter  ─┐
       └──> outbound-adapter ─┴──> application ───> domain
```

