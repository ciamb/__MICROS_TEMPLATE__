package __BASE_PACKAGE__.application.service;

import __BASE_PACKAGE__.application.port.in.GreetUseCase;
import __BASE_PACKAGE__.domain.service.GreetingService;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;

@ApplicationScoped
public class GreetService implements GreetUseCase {

    @Inject
    GreetingService greetingService;

    @Override
    public String greet(String name) {
        return greetingService.greet(name).message();
    }
}
