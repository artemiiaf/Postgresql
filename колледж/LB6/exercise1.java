class Logger {
    private static Logger instance;

    private Logger() {
        System.out.println("Получен экземпляр логгера.");
    }

    public static Logger getInstance() {
        if (instance == null) {
            instance = new Logger();
        }
        return instance;
    }

    public void log(String message) {
        System.out.println("[LOG] " + message);
    }
}

public class exercise1   {
    public static void main(String[] args) {
        Logger logger1 = Logger.getInstance();
        Logger logger2 = Logger.getInstance();

        boolean areSame = (logger1 == logger2);
        System.out.println("Ещё один вызов getInstance() вернул тот же объект? " + areSame);

        logger1.log("Привет, мир!");
    }
}
