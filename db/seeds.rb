# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rails db:seed command (or created
# alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings'
#   }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create(code: 'XYZ100', name: 'Account1', password: 'Account1')
Account.create(code: 'ABC100', name: 'Account2', password: 'Account2')
