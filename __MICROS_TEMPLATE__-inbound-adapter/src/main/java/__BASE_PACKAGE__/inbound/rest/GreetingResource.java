package __BASE_PACKAGE__.inbound.rest;

import __BASE_PACKAGE__.application.port.in.GreetUseCase;
import jakarta.inject.Inject;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.QueryParam;
import jakarta.ws.rs.core.MediaType;

@Path("/api/v1")
public class GreetingResource {

    @Inject
    GreetUseCase greetUseCase;

    @GET
    @Path("/greetings")
    @Produces(MediaType.TEXT_PLAIN)
    public String greet(@QueryParam("name") String name) {
        return greetUseCase.greet(name);
    }
}
