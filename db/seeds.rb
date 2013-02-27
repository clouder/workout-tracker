# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Workout.create(
  exercises: {
    squats: { reps: '', failures: 0, weight: 100 },
    benchpress: { reps: '', failures: 0, weight: 100 },
    rows: { reps: '', failures: 0, weight: 100 },
    overheadpress: { reps: '', failures: 0, weight: 100 },
    deadlifts: { reps: '', failures: 0, weight: 100 }
  }
)
