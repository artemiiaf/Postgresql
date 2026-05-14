class Pizza {
    private final String dough;
    private final String size;
    private final boolean cheese;
    private final String sauce;

    private Pizza(Builder builder) {
        this.dough = builder.dough;
        this.size = builder.size;
        this.cheese = builder.cheese;
        this.sauce = builder.sauce;
    }

    @Override
    public String toString() {
        return "Pizza [dough=" + dough + ", size=" + size + ", cheese=" + cheese + ", sauce=" + sauce + "]";
    }

    public static class Builder {
        private String dough;
        private String size;
        private boolean cheese;
        private String sauce;

        public Builder setDough(String dough) {
            this.dough = dough;
            return this;
        }

        public Builder setSize(String size) {
            this.size = size;
            return this;
        }

        public Builder addCheese() {
            this.cheese = true;
            return this;
        }

        public Builder setSauce(String sauce) {
            this.sauce = sauce;
            return this;
        }

        public Pizza build() {
            return new Pizza(this);
        }
    }
}

public class exercise4 {
    public static void main(String[] args) {
        Pizza pizza = new Pizza.Builder()
                .setDough("тонкое")
                .setSize("средняя")
                .addCheese()
                .setSauce("томатный")
                .build();

        System.out.println(pizza);
    }
}
