# Example program to insert data into details and quotes tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

begin

  # individual seed data sets

  # empty seed array
  ind_1 = {"county" => "Allegheny",
           # "municipality_name" => "",
           # "name" => "",
           # "street_address" => "",
           # "city" => "",
           # "zip_code" => "",
           # "municipality_code" => "",
           # "date_damaged" => "",
           # "longitude" => "",
           # "latitude" => "",
           # "location_notes" => "",
           # "primary_home" => "",
           # "renter" => "",
           # "foundation_home" => "",
           # "floor_frame_home" => "",
           # "exterior_walls_home" => "",
           # "roof_home" => "",
           # "interior_walls_home" => "",
           # "plumbing_home" => "",
           # "heating_ac_home" => "",
           # "electrical_home" => "",
           # "floor_frame_mobile" => "",
           # "exterior_walls_mobile" => "",
           # "roof_mobile" => "",
           # "interior_walls_mobile" => "",
           # "destroyed_home" => "",
           # "major_home" => "",
           # "minor_home" => "",
           # "affected_home" => "",
           # "inaccessible_home" => "",
           # "destroyed_mobile" => "",
           # "major_mobile" => "",
           # "minor_mobile" => "",
           # "affected_mobile" => "",
           # "inaccessible_mobile" => "",
           # "comments" => "",
           # "flood_insurance" => "",
           # "basement_water" => "",
           # "first_floor_water" => "",
           # "height_water" => "",
           # "add_comments" => "",
           # "assessor_name" => "",
           "date_assessed" => "04/04/2016"}

  # example seed array with values
  ind_2 = {"county" => "Allegheny",
           "municipality_name" => "Ohara Township",
           "name" => "John Doe",
           "street_address" => "123 Main Street",
           "city" => "Pittsburgh",
           "zip_code" => "15215",
           "municipality_code" => "700102",
           "date_damaged" => "01/26/2017",
           "longitude" => "40.502422",
           "latitude" => "-79.919777",
           # "location_notes" => "",
           "primary_home" => "yes",
           "renter" => "no",
           # "foundation_home" => "",
           # "floor_frame_home" => "",
           # "exterior_walls_home" => "",
           # "roof_home" => "",
           # "interior_walls_home" => "",
           # "plumbing_home" => "",
           # "heating_ac_home" => "",
           # "electrical_home" => "",
           # "floor_frame_mobile" => "",
           # "exterior_walls_mobile" => "",
           # "roof_mobile" => "",
           # "interior_walls_mobile" => "",
           # "destroyed_home" => "",
           # "major_home" => "",
           # "minor_home" => "",
           # "affected_home" => "",
           # "inaccessible_home" => "",
           # "destroyed_mobile" => "",
           # "major_mobile" => "",
           # "minor_mobile" => "",
           # "affected_mobile" => "",
           # "inaccessible_mobile" => "",
           "comments" => "Initial contact established, will assess on 4/18/2017.",
           # "flood_insurance" => "",
           # "basement_water" => "",
           # "first_floor_water" => "",
           # "height_water" => "",
           # "add_comments" => "",
           # "assessor_name" => "",
           "date_assessed" => "02/01/2016"}

ind_3 = {"county" => "Allegheny",
         "municipality_name" => "Pittsburgh City",
         "name" => "Phil Atwater",
         "street_address" => "1511 Fallowfield Ave",
         "city" => "Pittsburgh",
         "zip_code" => "15216",
         "municipality_code" => "700102",
         "date_damaged" => "3/30/2017",
         "longitude" => "-80.023639",
         "latitude" => "40.412542",
         "location_notes" => "middle of block",
         # "primary_home" => "",
         "renter" => "Yes",
         "foundation_home" => "5",
         "floor_frame_home" => "12",
         "exterior_walls_home" => "8",
         # "roof_home" => "",
         "interior_walls_home" => "8",
         "plumbing_home" => "7",
         "heating_ac_home" => "6",
         "electrical_home" => "6",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         # "major_home" => "",
         "minor_home" => "1",
         # "affected_home" => "",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Exterior walls still crumbling.",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         # "add_comments" => "",
         "assessor_name" => "Rick McClain",
         "date_assessed" => "3/31/17"}

ind_4 = {"county" => "Allegheny",
         "municipality_name" => "Pittsburgh City",
         "name" => "Bill Roberts",
         "street_address" => "4268 Stanton Ave",
         "city" => "Pittsburgh",
         "zip_code" => "15201",
         "municipality_code" => "700102",
         "date_damaged" => "3/27/2017",
         "longitude" => "-79.943900",
         "latitude" => "40.478869",
         "location_notes" => "White house; away from street",
         "primary_home" => "Yes",
         # "renter" => "",
         "foundation_home" => "3",
         "floor_frame_home" => "7",
         # "exterior_walls_home" => "",
         # "roof_home" => "",
         # "interior_walls_home" => "",
         "plumbing_home" => "4",
         # "heating_ac_home" => "",
         "electrical_home" => "2",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         # "major_home" => "",
         # "minor_home" => "",
         "affected_home" => "2",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Existing residual water- no drain-off",
         "flood_insurance" => "Yes",
         "basement_water" => "Yes",
         # "first_floor_water" => "",
         "height_water" => "2",
         "add_comments" => "",
         "assessor_name" => "Susan Eitner",
         "date_assessed" => "3/28/17"}

ind_5 = {"county" => "Allegheny",
         "municipality_name" => "Swissvale Boro",
         "name" => "Eileen Estevez",
         "street_address" => "925 Laclair St",
         "city" => "Pittsburgh",
         "zip_code" => "15218",
         "municipality_code" => "721010",
         "date_damaged" => "4/1/2017",
         "longitude" => "-79.897551",
         "latitude" => "40.434697",
         "location_notes" => "Nice Japanese split-leaf Maple in front yard",
         "primary_home" => "Yes",
         # "renter" => "",
         # "foundation_home" => "",
         # "floor_frame_home" => "",
         "exterior_walls_home" => "12",
         # "roof_home" => "",
         "interior_walls_home" => "20",
         # "plumbing_home" => "",
         "heating_ac_home" => "1",
         "electrical_home" => "2",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         # "major_home" => "",
         # "minor_home" => "",
         "affected_home" => "3",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Damage isolated",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         # "add_comments" => "",
         "assessor_name" => "Rob Reiner",
         "date_assessed" => "4/1/17"}

ind_6 = {"county" => "Allegheny",
         "municipality_name" => "Pittsburgh City",
         "name" => "Mary St. John",
         "street_address" => "5631 Carnegie",
         "city" => "Pittsburgh",
         "zip_code" => "15201",
         "municipality_code" => "700102",
         "date_damaged" => "3/17/2017",
         "longitude" => "-79.946466",
         "latitude" => "40.484571",
         "location_notes" => "Light-brown siding",
         # "primary_home" => "",
         "renter" => "Yes",
         # "foundation_home" => "",
         # "floor_frame_home" => "",
         "exterior_walls_home" => "6",
         "roof_home" => "9",
         "interior_walls_home" => "2",
         # "plumbing_home" => "",
         # "heating_ac_home" => "",
         # "electrical_home" => "",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         # "major_home" => "",
         # "minor_home" => "",
         # "affected_home" => "",
         "inaccessible_home" => "1",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Damage area roof & third floor walls only",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         # "add_comments" => "",
         "assessor_name" => "Bill Baxter",
         "date_assessed" => "3/18/17"}

ind_7 = {"county" => "Allegheny",
         "municipality_name" => "Mt Lebanon Twp",
         "name" => "James Pasteur",
         "street_address" => "116 Sunridge Dr",
         "city" => "Pittsburgh",
         "zip_code" => "15234",
         "municipality_code" => "731201",
         "date_damaged" => "3/20/2017",
         "longitude" => "-80.046197",
         "latitude" => "40.353598",
         # "location_notes" => "",
         "primary_home" => "Yes",
         # "renter" => "",
         # "foundation_home" => "",
         # "floor_frame_home" => "",
         "exterior_walls_home" => "2",
         "roof_home" => "1",
         # "interior_walls_home" => "",
         # "plumbing_home" => "",
         # "heating_ac_home" => "",
         # "electrical_home" => "",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         # "major_home" => "",
         "minor_home" => "1",
         # "affected_home" => "",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Tree fell into front left-side of house, causing slight structural damage to exterior walls and slight damage to roof",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         # "add_comments" => "",
         "assessor_name" => "Bill Baxter",
         "date_assessed" => "3/21/17"}

ind_8 = {"county" => "Allegheny",
         "municipality_name" => "Ross Twp",
         "name" => "Margaret Shelby",
         "street_address" => "4140 Perrysville Ave",
         "city" => "Pittsburgh",
         "zip_code" => "15214",
         "municipality_code" => "710801",
         "date_damaged" => "3/28/2017",
         "longitude" => "-80.021828",
         "latitude" => "40.493877",
         "location_notes" => "Corner residence",
         "primary_home" => "Yes",
         # "renter" => "",
         # "foundation_home" => "",
         # "floor_frame_home" => "",
         # "exterior_walls_home" => "",
         # "roof_home" => "",
         "interior_walls_home" => "25",
         # "plumbing_home" => "",
         "heating_ac_home" => "10",
         "electrical_home" => "6",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         "major_home" => "3",
         # "minor_home" => "",
         # "affected_home" => "",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Fire devastation to all interior walls",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         # "add_comments" => "",
         "assessor_name" => "Brett Masterson",
         "date_assessed" => "3/28/17"}

ind_9 = {"county" => "Allegheny",
         "municipality_name" => "Penn Hills Twp",
         "name" => "Frank Hatchett",
         "street_address" => "1706 Laporte St",
         "city" => "Pittsburgh",
         "zip_code" => "15206",
         "municipality_code" => "720501",
         "date_damaged" => "4/2/2017",
         "longitude" => "-79.889899",
         "latitude" => "40.471928",
         "location_notes" => "House runs up against woods",
         # "primary_home" => "",
         "renter" => "Yes",
         # "foundation_home" => "",
         # "floor_frame_home" => "",
         "exterior_walls_home" => "1",
         # "roof_home" => "",
         "interior_walls_home" => "27",
         # "plumbing_home" => "",
         # "heating_ac_home" => "",
         "electrical_home" => "6",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         "major_home" => "3",
         # "minor_home" => "",
         # "affected_home" => "",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Racoon infestation present",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         # "add_comments" => "",
         "assessor_name" => "Ruy Lopez",
         "date_assessed" => "4/3/17"}

ind_10 = {"county" => "Allegheny",
         "municipality_name" => "Mt Oliver Boro",
         "name" => "Sally Malone",
         "street_address" => "413 Otillia St",
         "city" => "Pittsburgh",
         "zip_code" => "15210",
         "municipality_code" => "700101",
         "date_damaged" => "3/15/2017",
         "longitude" => "-79.981672",
         "latitude" => "40.412466",
         "location_notes" => "House at crossroad of main street & alley",
         "primary_home" => "Yes",
         # "renter" => "",
         "foundation_home" => "7",
         "floor_frame_home" => "16",
         "exterior_walls_home" => "14",
         "roof_home" => "9",
         "interior_walls_home" => "28",
         "plumbing_home" => "10",
         "heating_ac_home" => "10",
         "electrical_home" => "6",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         "destroyed_home" => "3",
         # "major_home" => "",
         # "minor_home" => "",
         # "affected_home" => "",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "Residence entirely uninhabitable",
         "flood_insurance" => "Yes",
         "basement_water" => "Yes",
         "first_floor_water" => "Yes",
         "height_water" => "13",
         "add_comments" => "Family residing at shelter; prepare paperwork for extended stay",
         "assessor_name" => "Bill Baxter",
         "date_assessed" => "3/16/17"}

ind_11 = {"county" => "Allegheny",
         "municipality_name" => "Pittsburgh City",
         "name" => "Mike Presley",
         "street_address" => "3766 Windgap Ave",
         "city" => "Pittsburgh",
         "zip_code" => "15204",
         "municipality_code" => "700102",
         "date_damaged" => "3/09/2017",
         "longitude" => "-80.0790401",
         "latitude" => "40.458133",
         "location_notes" => "Parking accessible",
         # "primary_home" => "",
         "renter" => "Yes",
         # "foundation_home" => "",
         # "floor_frame_home" => "",
         # "exterior_walls_home" => "",
         # "roof_home" => "",
         # "interior_walls_home" => "",
         # "plumbing_home" => "",
         # "heating_ac_home" => "",
         "electrical_home" => "6",
         # "floor_frame_mobile" => "",
         # "exterior_walls_mobile" => "",
         # "roof_mobile" => "",
         # "interior_walls_mobile" => "",
         # "destroyed_home" => "",
         # "major_home" => "",
         # "minor_home" => "",
         "affected_home" => "1",
         # "inaccessible_home" => "",
         # "destroyed_mobile" => "",
         # "major_mobile" => "",
         # "minor_mobile" => "",
         # "affected_mobile" => "",
         # "inaccessible_mobile" => "",
         "comments" => "No electrical utilities ONLY",
         # "flood_insurance" => "",
         # "basement_water" => "",
         # "first_floor_water" => "",
         # "height_water" => "",
         "add_comments" => "Client belligerent",
         "assessor_name" => "Michelle Thomas",
         "date_assessed" => "3/09/17"}


  # aggregate user data into multi-dimensional array for iteration
  ind_forms = []
  ind_forms.push(ind_1, ind_2, ind_3, ind_4, ind_5, ind_6, ind_7, ind_8, ind_9, ind_10, ind_11)

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

  # local database connection
  # db_params = {
  #   dbname:ENV['dbname'],
  #   user:ENV['dbuser'],
  #   password:ENV['dbpassword']
  # }
  # conn = PG.connect(dbname: ENV['dbname'], user: ENV['dbuser'], password: ENV['dbpassword'])

  # determine current max index (id) in details table
  max_id = conn.exec("select max(id) from common")[0]

  # set index variable based on current max index value
  max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1

  # iterate through multi-dimensional users array for data
  ind_forms.each do |form|

    # initialize variables for SQL insert statements
    v_county = form["county"]
    v_municipality_name = form["municipality_name"]
    v_name = form["name"]
    v_street_address = form["street_address"]
    v_city = form["city"]
    v_zip_code = form["zip_code"]
    v_municipality_code = form["municipality_code"]
    v_date_damaged = form["date_damaged"]
    v_longitude = form["longitude"]
    v_latitude = form["latitude"]
    v_location_notes = form["location_notes"]
    v_primary_home = form["primary_home"]
    v_renter = form["renter"]
    v_foundation_home = form["foundation_home"]
    v_floor_frame_home = form["floor_frame_home"]
    v_exterior_walls_home = form["exterior_walls_home"]
    v_roof_home = form["roof_home"]
    v_interior_walls_home = form["interior_walls_home"]
    v_plumbing_home = form["plumbing_home"]
    v_heating_ac_home = form["heating_ac_home"]
    v_electrical_home = form["electrical_home"]
    v_floor_frame_mobile = form["floor_frame_mobile"]
    v_exterior_walls_mobile = form["exterior_walls_mobile"]
    v_roof_mobile = form["roof_mobile"]
    v_interior_walls_mobile = form["interior_walls_mobile"]
    v_destroyed_home = form["destroyed_home"]
    v_major_home = form["major_home"]
    v_minor_home = form["minor_home"]
    v_affected_home = form["affected_home"]
    v_inaccessible_home = form["inaccessible_home"]
    v_destroyed_mobile = form["destroyed_mobile"]
    v_major_mobile = form["major_mobile"]
    v_minor_mobile = form["minor_mobile"]
    v_affected_mobile = form["affected_mobile"]
    v_inaccessible_mobile = form["inaccessible_mobile"]
    v_comments = form["comments"]
    v_flood_insurance = form["flood_insurance"]
    v_basement_water = form["basement_water"]
    v_first_floor_water = form["first_floor_water"]
    v_height_water = form["height_water"]
    v_add_comments = form["add_comments"]
    v_assessor_name = form["assessor_name"]
    v_date_assessed = form["date_assessed"]

    # prepare SQL statement to insert common individual form fields into common table
    conn.prepare('q_statement',
                 "insert into common
                   (id, county, municipality_name)
                  values($1, $2, $3)")  # bind parameters

    # execute prepared SQL statement
    conn.exec_prepared('q_statement', [v_id, v_county, v_municipality_name])

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # prepare SQL statement to insert unique individual form fields into ind table
    conn.prepare('q_statement',
                 "insert into ind (id, common_id, name, street_address, city,
                    zip_code, municipality_code, date_damaged, longitude, latitude,
                    location_notes, primary_home, renter, foundation_home,
                    floor_frame_home, exterior_walls_home, roof_home,
                    interior_walls_home, plumbing_home, heating_ac_home,
                    electrical_home, floor_frame_mobile, exterior_walls_mobile,
                    roof_mobile, interior_walls_mobile, destroyed_home, major_home,
                    minor_home, affected_home, inaccessible_home, destroyed_mobile,
                    major_mobile, minor_mobile, affected_mobile, inaccessible_mobile,
                    comments, flood_insurance, basement_water, first_floor_water,
                    height_water, add_comments, assessor_name, date_assessed)
                  values($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
                    $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27,
                    $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40,
                    $41, $42, $43)")

    # execute prepared SQL statement
    conn.exec_prepared('q_statement', [v_id, v_id, v_name, v_street_address, v_city,
                    v_zip_code, v_municipality_code, v_date_damaged, v_longitude, v_latitude,
                    v_location_notes, v_primary_home, v_renter, v_foundation_home,
                    v_floor_frame_home, v_exterior_walls_home, v_roof_home,
                    v_interior_walls_home, v_plumbing_home, v_heating_ac_home,
                    v_electrical_home, v_floor_frame_mobile, v_exterior_walls_mobile,
                    v_roof_mobile, v_interior_walls_mobile, v_destroyed_home, v_major_home,
                    v_minor_home, v_affected_home, v_inaccessible_home, v_destroyed_mobile,
                    v_major_mobile, v_minor_mobile, v_affected_mobile, v_inaccessible_mobile,
                    v_comments, v_flood_insurance, v_basement_water, v_first_floor_water,
                    v_height_water, v_add_comments, v_assessor_name, v_date_assessed])

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # increment index value for next iteration
    v_id += 1

  end

rescue PG::Error => e

  puts 'Exception occurred'
  puts e.message

ensure

  conn.close if conn

end