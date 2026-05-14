interface Greeting {
    void sayHello();
}

class EnglishGreeting implements Greeting {
    @Override
    public void sayHello() {
        System.out.println("Hello!");
    }
}

class FrenchGreeting implements Greeting {
    @Override
    public void sayHello() {
        System.out.println("Bonjour!");
    }
}

class SpanishGreeting implements Greeting {
    @Override
    public void sayHello() {
        System.out.println("¡Hola!");
    }
}


class GreetingFactory {
    public Greeting createGreeting(String language) {
        if (language == null) {
            return null;
        }

        switch (language.toLowerCase().trim()) {
            case "english":
                return new EnglishGreeting();
            case "french":
                return new FrenchGreeting();
            case "spanish":
                return new SpanishGreeting();
            default:
                throw new IllegalArgumentException("Неизвестный язык: " + language);
        }
    }
}

public class exercise2 {
    public static void main(String[] args) {
        GreetingFactory factory = new GreetingFactory();
        Greeting englishGreeting = factory.createGreeting("english");
        englishGreeting.sayHello();
    }
}

