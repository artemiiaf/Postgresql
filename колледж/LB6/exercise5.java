    import java.util.Objects;

class Circle implements Cloneable {
    private int radius;
    private String color;

    public Circle(int radius, String color) {
        this.radius = radius;
        this.color = color;
    }

    public int getRadius() {
        return radius;
    }

    public void setRadius(int radius) {
        this.radius = radius;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    @Override
    public Circle clone() {
        try {
            return (Circle) super.clone();
        } catch (CloneNotSupportedException e) {
            throw new AssertionError();
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Circle circle = (Circle) o;
        return radius == circle.radius && Objects.equals(color, circle.color);
    }

    @Override
    public int hashCode() {
        return Objects.hash(radius, color);
    }

    @Override
    public String toString() {
        return "Circle [radius=" + radius + ", color=" + color + "]";
    }
}

public class exercise5 {
    public static void main(String[] args) {
        Circle original = new Circle(10, "red");
        System.out.println("Оригинал: " + original);

        Circle clone = original.clone();
        clone.setRadius(20);
        System.out.println("Клон: " + clone);

        System.out.println("Оригинал после изменения клона: " + original);

        boolean areDifferent = (original != clone);
        System.out.println("Оригинал и клон - разные объекты? " + areDifferent);
    }
}
