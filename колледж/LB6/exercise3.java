interface Button {
    void display();
}

interface Background {
    void display();
}

class LightButton implements Button {
    @Override
    public void display() {
        System.out.println("Светлая кнопка");
    }
}

class DarkButton implements Button {
    @Override
    public void display() {
        System.out.println("Тёмная кнопка");
    }
}

class LightBackground implements Background {
    @Override
    public void display() {
        System.out.println("Светлый фон");
    }
}

class DarkBackground implements Background {
    @Override
    public void display() {
        System.out.println("Тёмный фон");
    }
}

interface ThemeFactory {
    Button createButton();
    Background createBackground();
}

class LightThemeFactory implements ThemeFactory {
    @Override
    public Button createButton() {
        return new LightButton();
    }

    @Override
    public Background createBackground() {
        return new LightBackground();
    }
}

class DarkThemeFactory implements ThemeFactory {
    @Override
    public Button createButton() {
        return new DarkButton();
    }

    @Override
    public Background createBackground() {
        return new DarkBackground();
    }
}

public class exercise3 {
    public static void main(String[] args) {
        ThemeFactory factory = new LightThemeFactory();

        Button button = factory.createButton();
        Background background = factory.createBackground();

        button.display();
        background.display();
    }
}

