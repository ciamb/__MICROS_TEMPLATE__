package __BASE_PACKAGE__.domain.service;

import __BASE_PACKAGE__.domain.model.Greeting;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class GreetingService {

    public Greeting greet(String name) {
        var target = (name == null || name.isEmpty()) ? "world" : name.trim();
        return new Greeting("Hello %s from domain!".formatted(target));
    }
}
