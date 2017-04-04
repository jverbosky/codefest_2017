# Example program to return all data from details and quotes tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

def get_data()

  begin

  # connect to the database
  db_params = {  # AWS db
        host: ENV['host'],
        port:ENV['port'],
        dbname:ENV['dbname'],
        user:ENV['dbuser'],
        password:ENV['dbpassword']
      }
  # db_params = {  # local db
  #       dbname:ENV['dbname'],
  #       user:ENV['dbuser'],
  #       password:ENV['dbpassword']
  #     }
    conn = PG::Connection.new(db_params)

    # reference - example query to return all column names from details table
    # select column_name from information_schema.columns where table_name='details'

    # prepare SQL statement
    conn.prepare('q_statement',
                 "select *
                  from common
                  join ind on common.id = ind.common_id")

    # execute prepared SQL statement
    rs = conn.exec_prepared('q_statement')

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # return rs[0]


    # iterate through each row for user data and image
    rs.each do |row|

      # output user data to console
      p row

    end

  rescue PG::Error => e

    puts 'Exception occurred'
    puts e.message

  ensure

    conn.close if conn

  end

end

# Sandbox testing

get_data()

# Example output
# {"id"=>"1", "county"=>"Allegheny", "municipality_name"=>nil, "common_id"=>"1", "name"=>nil, "street_address"=>nil, "city"=>nil, "zip_code"=>nil, "municipality_code"=>nil, "date_damaged"=>nil, "longitude"=>nil, "latitude"=>nil, "location_notes"=>nil, "primary_home"=>nil, "renter"=>nil, "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>nil, "roof_home"=>nil, "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil,"major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>nil, "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>nil, "assessor_name"=>nil, "date_assessed"=>"2016-04-04"}
# {"id"=>"2", "county"=>"Allegheny", "municipality_name"=>"Ohara Township", "common_id"=>"2", "name"=>"John Doe", "street_address"=>"123 Main Street", "city"=>"Pittsburgh", "zip_code"=>"15215", "municipality_code"=>"700102", "date_damaged"=>"2017-01-26", "longitude"=>"40.502422", "latitude"=>"-79.919777", "location_notes"=>nil, "primary_home"=>"yes", "renter"=>"no", "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>nil, "roof_home"=>nil, "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Initial contact established, will assess on 4/18/2017.", "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>nil,"assessor_name"=>nil, "date_assessed"=>"2016-02-01"}