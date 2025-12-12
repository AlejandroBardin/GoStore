# frozen_string_literal: true

class ExercisesController < ApplicationController
  before_action :set_exercise, only: %i[show check_solution]

  TEST_CASES = [
    { price: 100, points: 0, code: "VIP", expected: 90.0, msg: "❌ El cálculo para VIP es incorrecto." },
    { price: 200, points: 150, code: "SEASONAL", expected: 170.0, msg: "❌ El cálculo para SEASONAL es incorrecto." },
    { price: 100, points: 0, code: "NONE", expected: 100.0, msg: "❌ El cálculo sin descuento es incorrecto." }
  ].freeze

  def show
    @submission = Current.user&.submissions&.find_by(exercise: @exercise)
  end

  def check_solution
    code = params[:code]
    result = evaluate_submission(code)
    status = result[:status] == "success" ? :passed : :failed

    submission = Current.user.submissions.find_or_initialize_by(exercise: @exercise)
    already_passed = submission.passed?
    submission.update(code: code, status: already_passed ? :passed : status)

    process_reward(result) if status == :passed && !already_passed

    render json: result
  end

  private

  def process_reward(result)
    reward = 100
    Current.user.wallet.deposit(reward)
    result[:message] += "\n\n🎉 ¡Has ganado #{reward} monedas! 🪙 Tu código es super elegante."
  end

  def evaluate_submission(code)
    return security_error if security_risk?(code)
    return static_analysis_error(code) if static_analysis_failed?(code)

    run_functional_tests(code)
  rescue SyntaxError => e
    { status: "error", message: "💥 Error de sintaxis: #{e.message}" }
  rescue StandardError => e
    { status: "error", message: "💥 Error al ejecutar tu código: #{e.message}" }
  end

  def security_risk?(code)
    code.match?(/\b(system|exec|`|File|Dir|IO|open|syscall)\b/)
  end

  def security_error
    { status: "error", message: "⚠️ Código rechazado por seguridad. No uses llamadas al sistema." }
  end

  def static_analysis_failed?(code)
    !code.include?("case") || code.include?("elsif")
  end

  def static_analysis_error(code)
    unless code.include?("case")
      return { status: "failure",
               message: "❌ Debes usar 'case' para refactorizar la lógica." }
    end

    { status: "failure", message: "❌ No debes usar 'elsif'. Usa 'case' y 'when'." }
  end

  def run_functional_tests(code)
    # Sandbox: Evaluar la clase en un contexto aislado
    eval(code) # rubocop:disable Security/Eval

    TEST_CASES.each do |test|
      unless correct_calculation?(test[:price], test[:points], test[:code], test[:expected])
        return { status: "failure", message: test[:msg] }
      end
    end

    { status: "success", message: "✅ ¡Excelente! Tu código funciona y es super elegante." }
  end

  def correct_calculation?(price, points, code, expected)
    order = Order.new([{ price: price, quantity: 1 }], { loyalty_points: points }, code)
    (order.total_price - expected).abs < 0.01
  end

  def set_exercise
    @exercise = Exercise.find(params[:id])
  end
end
