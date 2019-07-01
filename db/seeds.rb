# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

lincoln_hawk = Driver.create({name: 'Lincoln Falcão', age: 33, gender: :MALE})
lincoln_hawk.driver_license.create({category: :C, expiration_date: Time.new(2025,12,25)})
lincoln_hawk.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

# Carga Pesada
pedro = Driver.create({name: 'Pedro', age: 60, gender: :MALE})
pedro.driver_license.create({category: :C, expiration_date: Time.new(2025,01,25)})
pedro.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

bino = Driver.create({name: 'Bino', age: 58, gender: :MALE})
bino.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
bino.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

# Jorge - O brasileiro
jorge = Driver.create({name: 'Jorge', age: 58, gender: :MALE})
jorge.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
jorge.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

diane_ford = Driver.create({name: 'Diane Ford', age: 58, gender: :FEMALE})
diane_ford.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
diane_ford.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

# Jorge - O brasileiro
joao_miguel = Driver.create({name: 'João Miguel', age: 58, gender: :MALE})
joao_miguel.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
joao_miguel.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

al_capone = Driver.create({name: 'Al Capone', age: 58, gender: :MALE})
al_capone.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
al_capone.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

jack_crews = Driver.create({name: 'Jack Crews', age: 58, gender: :MALE})
jack_crews.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
jack_crews.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})

nilson_paula = Driver.create({name: 'Nilson de Paula', age: 58, gender: :MALE})
nilson_paula.driver_license.create({category: :C, expiration_date: Time.new(2023,07,25)})
nilson_paula.truck.create({category: :TOCO, model: 'Toco X', brand: 'Wolkswagen', driver_owner: true, is_loaded: false})