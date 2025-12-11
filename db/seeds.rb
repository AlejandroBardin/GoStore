# Clear existing data
Exercise.destroy_all
CourseModule.destroy_all

# Module 1
mod1 = CourseModule.create!(
  title: "Módulo I: Fundamentos y Refactoring",
  description: "Ejercicios básicos para entender la sintaxis y buenas prácticas en Ruby.",
  order: 1
)

# Exercise 1
Exercise.create!(
  title: "Refactoring: De if/else a case",
  description: <<~DESC,
    En este ejercicio, tienes una clase `Order` que calcula el precio total de una orden.
    El método `discount_amount` utiliza una lógica de `if/elsif/else` que se ha vuelto un poco desordenada.
    
    **Tu misión:**
    Refactorizar el método `discount_amount` para usar una estructura `case` que sea más limpia y legible.
  DESC
  initial_code: <<~CODE,
    class Order
      attr_reader :items, :customer, :discount_code
    
      VIP_DISCOUNT = 0.1
      SEASONAL_DISCOUNT = 0.15
      LOYALTY_THRESHOLD = 100
    
      def initialize(items, customer, discount_code)
        @items = items
        @customer = customer
        @discount_code = discount_code
      end
    
      def total_price
        (base_price - discount_amount).round(2)
      end
    
      private
    
      def base_price
        @base_price ||= items.sum { |item| item[:price] * item[:quantity] }
      end
    
      # --- 🛠️ ESTE ES EL MÉTODO QUE TENÉS QUE REFACTORIZAR ---
      def discount_amount
        # Misión: Cambiar esta lógica de if/elsif por un 'case' limpio
        if vip_or_loyal?
          base_price * VIP_DISCOUNT
        elsif seasonal_eligible?
          base_price * SEASONAL_DISCOUNT
        else
          0
        end
      end
      # -------------------------------------------------------
    
      def vip_or_loyal?
        ["VIP", "LOYAL"].include?(@discount_code)
      end
    
      def seasonal_eligible?
        @discount_code == "SEASONAL" && @customer[:loyalty_points] > LOYALTY_THRESHOLD
      end
    end
  CODE
  solution_code: <<~CODE,
    def discount_amount
      case
      when vip_or_loyal?
        base_price * VIP_DISCOUNT
      when seasonal_eligible?
        base_price * SEASONAL_DISCOUNT
      else
        0
      end
    end
  CODE
  order: 1,
  course_module: mod1
)

puts "Seeds created successfully!"
