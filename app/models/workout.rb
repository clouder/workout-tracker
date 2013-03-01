class Workout < ActiveRecord::Base
  serialize :exercises, Hash
  attr_accessible :exercises
  before_save :complete_set

  state_machine initial: :squats_a do
    state :squats_a
    state :benchpress
    state :rows
    state :squats_b
    state :overheadpress
    state :deadlifts

    event :change_exercise do
      transition to: :squats_a, from: :deadlifts
      transition to: :benchpress, from: :squats_a
      transition to: :rows, from: :benchpress
      transition to: :squats_b, from: :rows
      transition to: :overheadpress, from: :squats_b
      transition to: :deadlifts, from: :overheadpress
    end
  end

  def exercise
    state.gsub(/_./, '')
  end

  def weight
    exercises[exercise.to_sym][:weight]
  end

  def previous_sets
    exercises[exercise.to_sym][:reps]
  end

  def add_set(reps)
    exercises[exercise.to_sym][:reps] += reps
  end

  def total_sets
    exercises[exercise.to_sym][:reps].size
  end

  def total_reps
    exercises[exercise.to_sym][:reps].split('').map { |reps| reps.to_i }.sum
  end

  def complete_set
    increment_failures if failure?
    increase_weight if success?
    next_exercise
  end

  def next_exercise
    if exercise == 'deadlifts' && total_sets == 1
      exercises[exercise.to_sym][:reps] = ''
      change_exercise
    elsif total_sets == 5
      exercises[exercise.to_sym][:reps] = ''
      change_exercise
    end
  end

  def increment_failures
    failures = exercises[exercise.to_sym][:failures] += 1
    drop_weight if failures == 3
  end

  def reset_failures
    exercises[exercise.to_sym][:failures] = 0
  end

  def drop_weight
    weight = exercises[exercise.to_sym][:weight]
    weight = (weight * 0.9).floor
    weight = weight - (weight % 5)
    exercises[exercise.to_sym][:weight] = weight
    reset_failures
  end

  def increase_weight
    exercises[exercise.to_sym][:weight] += 5
    exercises[exercise.to_sym][:weight] += 5 if exercise == 'deadlifts'
    reset_failures
  end

  def rest_duration
    failures = exercises[exercise.to_sym][:failures]
    case failures
    when 1
      180
    when 2
      300
    else
      90
    end
  end

  def success?
    if exercise == 'deadlifts'
      total_sets == 1 && total_reps > 4
    else
      total_sets == 5 && total_reps > 24
    end
  end

  def failure?
    if exercise == 'deadlifts'
      total_sets == 1 && total_reps < 5
    else
      total_sets == 5 && total_reps < 25
    end
  end
end
