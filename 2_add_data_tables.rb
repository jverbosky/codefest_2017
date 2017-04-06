# Example program to insert data into details and quotes tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

############################
# Seed common + ind tables #
############################

def seed_individual()

  begin

    # individual seed data sets
    ind_1 = {"county" => "Allegheny",
             "municipality_name" => "Ohara Twp",
             "name" => "John Doe",
             "street_address" => "123 Main St",
             "city" => "Pittsburgh",
             "zip_code" => "15215",
             "municipality_code" => "700102",
             "date_damaged" => "01/26/2017",
             "longitude" => "40.502422",
             "latitude" => "-79.919777",
             "primary_home" => "yes",
             "comments" => "Initial contact established, will assess on 4/18/2017",
             "assessor_name" => "George Watson",
             "date_assessed" => "02/01/2016"}

    ind_2 = {"county" => "Allegheny",
             "municipality_name" => "Pittsburgh City",
             "name" => "Phil Atwater",
             "street_address" => "1511 Fallowfield Ave",
             "city" => "Pittsburgh",
             "zip_code" => "15216",
             "municipality_code" => "700102",
             "date_damaged" => "3/30/2017",
             "longitude" => "-80.023639",
             "latitude" => "40.412542",
             "location_notes" => "Middle of block",
             "renter" => "yes",
             "foundation_home" => "5",
             "floor_frame_home" => "12",
             "exterior_walls_home" => "8",
             "interior_walls_home" => "8",
             "plumbing_home" => "7",
             "heating_ac_home" => "6",
             "electrical_home" => "6",
             "minor_home" => "1",
             "comments" => "Exterior walls still crumbling",
             "assessor_name" => "Rick McClain",
             "date_assessed" => "3/31/17"}

    ind_3 = {"county" => "Allegheny",
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
             "primary_home" => "yes",
             "foundation_home" => "3",
             "floor_frame_home" => "7",
             "plumbing_home" => "4",
             "electrical_home" => "2",
             "affected_home" => "2",
             "comments" => "Existing residual water - no drain-off",
             "flood_insurance" => "yes",
             "basement_water" => "yes",
             "height_water" => "2",
             "assessor_name" => "Susan Eitner",
             "date_assessed" => "3/28/17"}

    ind_4 = {"county" => "Allegheny",
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
             "primary_home" => "yes",
             "exterior_walls_home" => "12",
             "interior_walls_home" => "20",
             "heating_ac_home" => "1",
             "electrical_home" => "2",
             "affected_home" => "3",
             "comments" => "Damage isolated",
             "assessor_name" => "Rob Reiner",
             "date_assessed" => "4/1/17"}

    ind_5 = {"county" => "Allegheny",
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
             "renter" => "yes",
             "exterior_walls_home" => "6",
             "roof_home" => "9",
             "interior_walls_home" => "2",
             "inaccessible_home" => "1",
             "comments" => "Damage area roof & third floor walls only",
             "assessor_name" => "Bill Baxter",
             "date_assessed" => "3/18/17"}

    ind_6 = {"county" => "Allegheny",
             "municipality_name" => "Mt Lebanon Twp",
             "name" => "James Pasteur",
             "street_address" => "116 Sunridge Dr",
             "city" => "Pittsburgh",
             "zip_code" => "15234",
             "municipality_code" => "731201",
             "date_damaged" => "3/20/2017",
             "longitude" => "-80.046197",
             "latitude" => "40.353598",
             "primary_home" => "yes",
             "exterior_walls_home" => "2",
             "roof_home" => "1",
             "minor_home" => "1",
             "comments" => "Tree fell into front left-side of house, causing slight structural damage to exterior walls and slight damage to roof",
             "assessor_name" => "Bill Baxter",
             "date_assessed" => "3/21/17"}

    ind_7 = {"county" => "Allegheny",
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
             "primary_home" => "yes",
             "interior_walls_home" => "25",
             "heating_ac_home" => "10",
             "electrical_home" => "6",
             "major_home" => "3",
             "comments" => "Fire devastation to all interior walls",
             "assessor_name" => "Brett Masterson",
             "date_assessed" => "3/28/17"}

    ind_8 = {"county" => "Allegheny",
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
             "renter" => "yes",
             "exterior_walls_home" => "1",
             "interior_walls_home" => "27",
             "electrical_home" => "6",
             "major_home" => "3",
             "comments" => "Racoon infestation present",
             "assessor_name" => "Ruy Lopez",
             "date_assessed" => "4/3/17"}

    ind_9 = {"county" => "Allegheny",
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
             "primary_home" => "yes",
             "foundation_home" => "7",
             "floor_frame_home" => "16",
             "exterior_walls_home" => "14",
             "roof_home" => "9",
             "interior_walls_home" => "28",
             "plumbing_home" => "10",
             "heating_ac_home" => "10",
             "electrical_home" => "6",
             "destroyed_home" => "3",
             "comments" => "Residence entirely uninhabitable",
             "flood_insurance" => "yes",
             "basement_water" => "yes",
             "first_floor_water" => "yes",
             "height_water" => "13",
             "add_comments" => "Family residing at shelter; prepare paperwork for extended stay",
             "assessor_name" => "Bill Baxter",
             "date_assessed" => "3/16/17"}

    ind_10 = {"county" => "Allegheny",
             "municipality_name" => "Pittsburgh City",
             "name" => "Mike Presley",
             "street_address" => "3766 Windgap Ave",
             "city" => "Pittsburgh",
             "zip_code" => "15204",
             "municipality_code" => "700102",
             "date_damaged" => "3/09/2017",
             "longitude" => "-80.079105",
             "latitude" => "40.458133",
             "location_notes" => "Parking accessible",
             "renter" => "yes",
             "electrical_home" => "6",
             "affected_home" => "1",
             "comments" => "No electrical utilities ONLY",
             "add_comments" => "Client belligerent",
             "assessor_name" => "Michelle Thomas",
             "date_assessed" => "3/09/17"}

    ind_11 = {"county" => "Allegheny",
             "municipality_name" => "Pittsburgh City",
             "name" => "Ralph Bronstein",
             "street_address" => "1 Trimont Lane 820b",
             "city" => "Pittsburgh",
             "zip_code" => "15211",
             "municipality_code" => "700102",
             "date_damaged" => "3/19/2017",
             "longitude" => "-80.020206",
             "latitude" => "40.438221",
             "location_notes" => "Top of the hill",
             "primary_home" => "yes",
             "roof_home" => "9",
             "major_home" => "3",
             "add_comments" => "Multi-million dollar structure",
             "assessor_name" => "Josey Wales",
             "date_assessed" => "3/19/17"}

    ind_12 = {"county" => "Allegheny",
             "municipality_name" => "Scott Twp",
             "name" => "Ralph Bronstein",
             "street_address" => "421 Morrison Dr",
             "city" => "Pittsburgh",
             "zip_code" => "15216",
             "municipality_code" => "730504",
             "date_damaged" => "4/3/2017",
             "longitude" => "-80.056103",
             "latitude" => "40.390707",
             "location_notes" => "Heading N on Cochran, make a right & follow cul-de-sac",
             "primary_home" => "yes",
             "exterior_walls_home" => "3",
             "roof_home" => "6",
             "major_home" => "2",
             "comments" => "Entire chimney destroyed, along with east-side wall",
             "assessor_name" => "Barbara Schropshire",
             "date_assessed" => "4/3/17"}

    ind_13 = {"county" => "Allegheny",
             "municipality_name" => "Munhall Boro",
             "name" => "Bill Davis Rolfe",
             "street_address" => "4589 Mapledale Dr",
             "city" => "Pittsburgh",
             "zip_code" => "15120",
             "municipality_code" => "731502",
             "date_damaged" => "3/10/2017",
             "longitude" => "-79.920322",
             "latitude" => "40.386482",
             "location_notes" => "Residence set-back from street",
             "renter" => "yes",
             "foundation_home" => "7",
             "floor_frame_home" => "16",
             "exterior_walls_home" => "14",
             "roof_home" => "9",
             "interior_walls_home" => "28",
             "plumbing_home" => "10",
             "heating_ac_home" => "10",
             "electrical_home" => "6",
             "destroyed_home" => "3",
             "comments" => "Entire dwelling uninhabitable, restoration not feasible",
             "flood_insurance" => "yes",
             "basement_water" => "yes",
             "first_floor_water" => "yes",
             "height_water" => "16",
             "add_comments" => "Family still in process of salvaging possesions; directed them to vacate by 3 PM",
             "assessor_name" => "Anne Goldstein",
             "date_assessed" => "3/11/17"}

    ind_14 = {"county" => "Allegheny",
             "municipality_name" => "West Homestead Boro",
             "name" => "David Rolfe",
             "street_address" => "607 Somerville Dr",
             "city" => "Pittsburgh",
             "zip_code" => "15243",
             "municipality_code" => "731503",
             "date_damaged" => "3/25/2017",
             "longitude" => "-80.076517",
             "latitude" => "40.367906",
             "location_notes" => "Corner house",
             "primary_home" => "yes",
             "foundation_home" => "2",
             "floor_frame_home" => "1",
             "exterior_walls_home" => "1",
             "interior_walls_home" => "2",
             "minor_home" => "1",
             "comments" => "Minimal interior damage; main issue: hill erosion causing house to lean, main damage to south wall & deck",
             "add_comments" => "N/A",
             "assessor_name" => "Anne Goldstein",
             "date_assessed" => "3/26/17"}

    ind_15 = {"county" => "Allegheny",
             "municipality_name" => "Green Tree Boro",
             "name" => "Howard Domers",
             "street_address" => "1967 Warriors Rd",
             "city" => "Pittsburgh",
             "zip_code" => "15205",
             "municipality_code" => "730903",
             "date_damaged" => "3/27/2017",
             "longitude" => "-80.046834",
             "latitude" => "40.428623",
             "location_notes" => "House located at Elmdale & Warriors intersection",
             "renter" => "yes",
             "foundation_home" => "7",
             "affected_home" => "1",
             "comments" => "Vaguest damage present only in foundation",
             "add_comments" => "Crew scheduled to arrive 9 AM to commence repairs; should complete in 1 day",
             "assessor_name" => "Donna Liberti",
             "date_assessed" => "3/28/17"}

    ind_16 = {"county" => "Allegheny",
             "municipality_name" => "Pittsburgh City",
             "name" => "Richard Flanagan",
             "street_address" => "405 E Carson St",
             "city" => "Pittsburgh",
             "zip_code" => "15203",
             "municipality_code" => "700102",
             "date_damaged" => "4/4/2017",
             "longitude" => "-79.996076",
             "latitude" => "40.429351",
             "location_notes" => "House located next to Gaynor's School of Cooking",
             "renter" => "yes",
             "exterior_walls_home" => "14",
             "roof_home" => "9",
             "electrical_home" => "6",
             "major_home" => "1",
             "add_comments" => "Family evacuated to shelter; arrangements commenced for housing of pets",
             "assessor_name" => "Rich Ruggieri",
             "date_assessed" => "4/5/17"}

    ind_17 = {"county" => "Allegheny",
             "municipality_name" => "Mt Lebanon Twp",
             "name" => "Sam Gamgee",
             "street_address" => "251 Questend Ave",
             "city" => "Pittsburgh",
             "zip_code" => "15228",
             "municipality_code" => "731201",
             "date_damaged" => "3/2/2017",
             "longitude" => "-80.034229",
             "latitude" => "40.378104",
             "location_notes" => "Heading South on Sunset Dr., turn right onto Questend",
             "primary_home" => "yes",
             "roof_home" => "9",
             "major_home" => "2",
             "comments" => "See below",
             "add_comments" => "Occupancy feasible - damage to roof over sealed-off third-floor",
             "assessor_name" => "Frank Kenny",
             "date_assessed" => "3/2/17"}

    ind_18 = {"county" => "Allegheny",
             "municipality_name" => "Baldwin Boro",
             "name" => "Thomas Sawyer",
             "street_address" => "645 Calera St",
             "city" => "Pittsburgh",
             "zip_code" => "15207",
             "municipality_code" => "730101",
             "date_damaged" => "2/1/2017",
             "longitude" => "-79.933472",
             "latitude" => "40.381244",
             "location_notes" => "White mobile-home, red awning",
             "renter" => "yes",
             "floor_frame_mobile" => "20",
             "exterior_walls_mobile" => "35",
             "roof_mobile" => "20",
             "interior_walls_mobile" => "25",
             "destroyed_mobile" => "3",
             "comments" => "Irreparable; see below",
             "add_comments" => "Nothing salvageable but scrap",
             "assessor_name" => "Phil Blint",
             "date_assessed" => "2/1/17"}

    ind_19 = {"county" => "Allegheny",
             "municipality_name" => "Pittsburgh City",
             "name" => "Gerry Fichte",
             "street_address" => "5741 Kentucky Ave",
             "city" => "Pittsburgh",
             "zip_code" => "15232",
             "municipality_code" => "700102",
             "date_damaged" => "3/1/2017",
             "longitude" => "-79.928699",
             "latitude" => "40.451191",
             "location_notes" => "Kentucky Ave. @ Osterburg Way",
             "primary_home" => "yes",
             "plumbing_home" => "10",
             "heating_ac_home" => "10",
             "electrical_home" => "6",
             "minor_home" => "2",
             "comments" => "Flooding damaged electrical system, and A/C System",
             "flood_insurance" => "no",
             "basement_water" => "yes",
             "first_floor_water" => "yes",
             "height_water" => "1.5",
             "add_comments" => "Electrical contractor scheduled at 10 AM on 3/3/17",
             "assessor_name" => "Bob Byrd",
             "date_assessed" => "3/2/17"}

    # aggregate user data into multi-dimensional array for iteration
    ind_forms = []
    ind_forms.push(ind_1, ind_2, ind_3, ind_4, ind_5, ind_6, ind_7, ind_8, ind_9, ind_10,
                   ind_11, ind_12, ind_13, ind_14, ind_15, ind_16, ind_17, ind_18, ind_19)

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

    # determine current max index (id) in details table
    max_id = conn.exec("select max(id) from common")[0]

    # set index variable based on current max index value
    max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1

    # iterate through multi-dimensional users array for data
    ind_forms.each do |form|

      # initialize variables for SQL insert statements (common table)
      v_county = form["county"]
      v_municipality_name = form["municipality_name"]

      # prepare SQL statement to insert common individual form fields into common table
      conn.prepare('q_statement',
                   "insert into common
                     (id, county, municipality_name)
                    values($1, $2, $3)")  # bind parameters

      # execute prepared SQL statement
      conn.exec_prepared('q_statement', [v_id, v_county, v_municipality_name])

      # deallocate prepared statement variable (avoid error "prepared statement already exists")
      conn.exec("deallocate q_statement")

      # initialize variables for SQL insert statements (ind table)
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

end

################################
# Seed common + ind_pda tables #
################################

def seed_individual_pda()

  begin

    # individual seed data sets
    ind_pda_1 = {"county" => "Allegheny",
                 "municipality_name" => "Mt Oliver Boro",
                 "pda_date" => "03/18/2017",
                 "incident_type" => "subsidence",  # flood, tornado, subsidence, fire
                 "page" => "1",
                 "total_pages" => "1",
                 "pda_team_hlo" => "",  # need clarification on valid value here
                 "af_own_single" => "1",
                 "af_own_multi" => "0",
                 "af_own_mob" => "0",
                 "af_own_p_fl_ins" => "0",
                 "af_own_p_ho_ins" => "0",
                 "af_own_p_lo_inc" => "0",
                 "af_own_num_inac" => "1",
                 "af_rent_single" => "0",
                 "af_rent_multi" => "0",
                 "af_rent_mob" => "0",
                 "af_rent_p_fl_ins" => "0",
                 "af_rent_p_ho_ins" => "0",
                 "af_rent_p_lo_inc" => "0",
                 "af_rent_num_inac" => "0",
                 "af_sec_single" => "0",
                 "af_sec_multi" => "0",
                 "af_sec_mob" => "0",
                 "mn_own_single" => "0",
                 "mn_own_multi" => "0",
                 "mn_own_mob" => "0",
                 "mn_own_p_fl_ins" => "0",
                 "mn_own_p_ho_ins" => "0",
                 "mn_own_p_lo_inc" => "0",
                 "mn_own_num_inac" => "0",
                 "mn_rent_single" => "0",
                 "mn_rent_multi" => "0",
                 "mn_rent_mob" => "0",
                 "mn_rent_p_fl_ins" => "0",
                 "mn_rent_p_ho_ins" => "0",
                 "mn_rent_p_lo_inc" => "0",
                 "mn_rent_num_inac" => "0",
                 "mn_sec_single" => "0",
                 "mn_sec_multi" => "0",
                 "mn_sec_mob" => "0",
                 "mj_own_single" => "0",
                 "mj_own_multi" => "0",
                 "mj_own_mob" => "0",
                 "mj_own_p_fl_ins" => "0",
                 "mj_own_p_ho_ins" => "0",
                 "mj_own_p_lo_inc" => "0",
                 "mj_own_num_inac" => "0",
                 "mj_rent_single" => "0",
                 "mj_rent_multi" => "0",
                 "mj_rent_mob" => "0",
                 "mj_rent_p_fl_ins" => "0",
                 "mj_rent_p_ho_ins" => "0",
                 "mj_rent_p_lo_inc" => "0",
                 "mj_rent_num_inac" => "0",
                 "mj_sec_single" => "0",
                 "mj_sec_multi" => "0",
                 "mj_sec_mob" => "0",
                 "d_own_single" => "0",
                 "d_own_multi" => "0",
                 "d_own_mob" => "0",
                 "d_own_p_fl_ins" => "0",
                 "d_own_p_ho_ins" => "0",
                 "d_own_p_lo_inc" => "0",
                 "d_own_num_inac" => "0",
                 "d_rent_single" => "0",
                 "d_rent_multi" => "0",
                 "d_rent_mob" => "0",
                 "d_rent_p_fl_ins" => "0",
                 "d_rent_p_ho_ins" => "0",
                 "d_rent_p_lo_inc" => "0",
                 "d_rent_num_inac" => "0",
                 "d_sec_single" => "0",
                 "d_sec_multi" => "0",
                 "d_sec_mob" => "0",
                 "roads_bridges_damaged" => "1",
                 "households_impacted" => "1",
                 "households_no_utilities" => "0",
                 "comments" => "10' wide sinkhole at Lacrosse St near 2117 Lacrosse St"}

    ind_pda_2 = {"county" => "Allegheny",
                 "municipality_name" => "Mt Oliver Boro",
                 "pda_date" => "03/18/2017",
                 "incident_type" => "flood",  # flood, tornado, subsidence, fire
                 "page" => "1",
                 "total_pages" => "1",
                 "pda_team_hlo" => "",  # need clarification on valid value here
                 "af_own_single" => "9",
                 "af_own_multi" => "3",
                 "af_own_mob" => "0",
                 "af_own_p_fl_ins" => "25",
                 "af_own_p_ho_ins" => "75",
                 "af_own_p_lo_inc" => "25",
                 "af_own_num_inac" => "2",
                 "af_rent_single" => "0",
                 "af_rent_multi" => "4",
                 "af_rent_mob" => "0",
                 "af_rent_p_fl_ins" => "0",
                 "af_rent_p_ho_ins" => "50",
                 "af_rent_p_lo_inc" => "75",
                 "af_rent_num_inac" => "1",
                 "af_sec_single" => "0",
                 "af_sec_multi" => "0",
                 "af_sec_mob" => "0",
                 "mn_own_single" => "3",
                 "mn_own_multi" => "0",
                 "mn_own_mob" => "0",
                 "mn_own_p_fl_ins" => "100",
                 "mn_own_p_ho_ins" => "100",
                 "mn_own_p_lo_inc" => "0",
                 "mn_own_num_inac" => "3",
                 "mn_rent_single" => "0",
                 "mn_rent_multi" => "1",
                 "mn_rent_mob" => "0",
                 "mn_rent_p_fl_ins" => "0",
                 "mn_rent_p_ho_ins" => "100",
                 "mn_rent_p_lo_inc" => "100",
                 "mn_rent_num_inac" => "1",
                 "mn_sec_single" => "0",
                 "mn_sec_multi" => "0",
                 "mn_sec_mob" => "0",
                 "mj_own_single" => "2",
                 "mj_own_multi" => "0",
                 "mj_own_mob" => "0",
                 "mj_own_p_fl_ins" => "50",
                 "mj_own_p_ho_ins" => "100",
                 "mj_own_p_lo_inc" => "0",
                 "mj_own_num_inac" => "2",
                 "mj_rent_single" => "0",
                 "mj_rent_multi" => "0",
                 "mj_rent_mob" => "0",
                 "mj_rent_p_fl_ins" => "0",
                 "mj_rent_p_ho_ins" => "0",
                 "mj_rent_p_lo_inc" => "0",
                 "mj_rent_num_inac" => "0",
                 "mj_sec_single" => "0",
                 "mj_sec_multi" => "0",
                 "mj_sec_mob" => "0",
                 "d_own_single" => "0",
                 "d_own_multi" => "0",
                 "d_own_mob" => "0",
                 "d_own_p_fl_ins" => "0",
                 "d_own_p_ho_ins" => "0",
                 "d_own_p_lo_inc" => "0",
                 "d_own_num_inac" => "0",
                 "d_rent_single" => "0",
                 "d_rent_multi" => "0",
                 "d_rent_mob" => "0",
                 "d_rent_p_fl_ins" => "0",
                 "d_rent_p_ho_ins" => "0",
                 "d_rent_p_lo_inc" => "0",
                 "d_rent_num_inac" => "0",
                 "d_sec_single" => "0",
                 "d_sec_multi" => "0",
                 "d_sec_mob" => "0",
                 "roads_bridges_damaged" => "1",
                 "households_impacted" => "40",
                 "households_no_utilities" => "10",
                 "est_date_utility_restore" => "03/25/2017",
                 "comments" => "Preliminary data - will need to assess further to determine entire scope."}

    # aggregate user data into multi-dimensional array for iteration
    ind_pda_forms = []
    ind_pda_forms.push(ind_pda_1, ind_pda_2)

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

    # determine current max index (id) in details table
    max_id = conn.exec("select max(id) from common")[0]

    # set index variable based on current max index value
    max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1

    # iterate through multi-dimensional users array for data
    ind_pda_forms.each do |form|

      # initialize variables for SQL insert statements (common table)
      v_county = form["county"]
      v_municipality_name = form["municipality_name"]

      # prepare SQL statement to insert common individual form fields into common table
      conn.prepare('q_statement',
                   "insert into common
                     (id, county, municipality_name)
                    values($1, $2, $3)")  # bind parameters

      # execute prepared SQL statement
      conn.exec_prepared('q_statement', [v_id, v_county, v_municipality_name])

      # deallocate prepared statement variable (avoid error "prepared statement already exists")
      conn.exec("deallocate q_statement")

      # initialize variables for SQL insert statements (ind_pda table)
      v_pda_date = form["pda_date"]
      v_incident_type  = form["incident_type"]
      v_page  = form["page"]
      v_total_pages  = form["total_pages"]
      v_pda_team_fema  = form["pda_team_fema"]
      v_pda_team_state = form["pda_team_state"]
      v_pda_team_sba = form["pda_team_sba"]
      v_pda_team_hlo = form["pda_team_hlo"]
      v_af_own_single = form["af_own_single"]
      v_af_own_multi = form["af_own_multi"]
      v_af_own_mob = form["af_own_mob"]
      v_af_own_p_fl_ins = form["af_own_p_fl_ins"]
      v_af_own_p_ho_ins = form["af_own_p_ho_ins"]
      v_af_own_p_lo_inc = form["af_own_p_lo_inc"]
      v_af_own_num_inac = form["af_own_num_inac"]
      v_af_rent_single = form["af_rent_single"]
      v_af_rent_multi = form["af_rent_multi"]
      v_af_rent_mob = form["af_rent_mob"]
      v_af_rent_p_fl_ins = form["af_rent_p_fl_ins"]
      v_af_rent_p_ho_ins = form["af_rent_p_ho_ins"]
      v_af_rent_p_lo_inc = form["af_rent_p_lo_inc"]
      v_af_rent_num_inac = form["af_rent_num_inac"]
      v_af_sec_single = form["af_sec_single"]
      v_af_sec_multi = form["af_sec_multi"]
      v_af_sec_mob = form["af_sec_mob"]
      v_mn_own_single = form["mn_own_single"]
      v_mn_own_multi = form["mn_own_multi"]
      v_mn_own_mob = form["mn_own_mob"]
      v_mn_own_p_fl_ins = form["mn_own_p_fl_ins"]
      v_mn_own_p_ho_ins = form["mn_own_p_ho_ins"]
      v_mn_own_p_lo_inc = form["mn_own_p_lo_inc"]
      v_mn_own_num_inac = form["mn_own_num_inac"]
      v_mn_rent_single = form["mn_rent_single"]
      v_mn_rent_multi = form["mn_rent_multi"]
      v_mn_rent_mob = form["mn_rent_mob"]
      v_mn_rent_p_fl_ins = form["mn_rent_p_fl_ins"]
      v_mn_rent_p_ho_ins = form["mn_rent_p_ho_ins"]
      v_mn_rent_p_lo_inc = form["mn_rent_p_lo_inc"]
      v_mn_rent_num_inac = form["mn_rent_num_inac"]
      v_mn_sec_single = form["mn_sec_single"]
      v_mn_sec_multi = form["mn_sec_multi"]
      v_mn_sec_mob = form["mn_sec_mob"]
      v_mj_own_single = form["mj_own_single"]
      v_mj_own_multi = form["mj_own_multi"]
      v_mj_own_mob = form["mj_own_mob"]
      v_mj_own_p_fl_ins = form["mj_own_p_fl_ins"]
      v_mj_own_p_ho_ins = form["mj_own_p_ho_ins"]
      v_mj_own_p_lo_inc = form["mj_own_p_lo_inc"]
      v_mj_own_num_inac = form["mj_own_num_inac"]
      v_mj_rent_single = form["mj_rent_single"]
      v_mj_rent_multi = form["mj_rent_multi"]
      v_mj_rent_mob = form["mj_rent_mob"]
      v_mj_rent_p_fl_ins = form["mj_rent_p_fl_ins"]
      v_mj_rent_p_ho_ins = form["mj_rent_p_ho_ins"]
      v_mj_rent_p_lo_inc = form["mj_rent_p_lo_inc"]
      v_mj_rent_num_inac = form["mj_rent_num_inac"]
      v_mj_sec_single = form["mj_sec_single"]
      v_mj_sec_multi = form["mj_sec_multi"]
      v_mj_sec_mob = form["mj_sec_mob"]
      v_d_own_single = form["d_own_single"]
      v_d_own_multi = form["d_own_multi"]
      v_d_own_mob = form["d_own_mob"]
      v_d_own_p_fl_ins = form["d_own_p_fl_ins"]
      v_d_own_p_ho_ins = form["d_own_p_ho_ins"]
      v_d_own_p_lo_inc = form["d_own_p_lo_inc"]
      v_d_own_num_inac = form["d_own_num_inac"]
      v_d_rent_single = form["d_rent_single"]
      v_d_rent_multi = form["d_rent_multi"]
      v_d_rent_mob = form["d_rent_mob"]
      v_d_rent_p_fl_ins = form["d_rent_p_fl_ins"]
      v_d_rent_p_ho_ins = form["d_rent_p_ho_ins"]
      v_d_rent_p_lo_inc = form["d_rent_p_lo_inc"]
      v_d_rent_num_inac = form["d_rent_num_inac"]
      v_d_sec_single = form["d_sec_single"]
      v_d_sec_multi = form["d_sec_multi"]
      v_d_sec_mob = form["d_sec_mob"]
      v_roads_bridges_damaged = form["roads_bridges_damaged"]
      v_households_impacted = form["households_impacted"]
      v_households_no_utilities = form["households_no_utilities"]
      v_est_date_utility_restore = form["est_date_utility_restore"]
      v_comments = form["comments"]

      # prepare SQL statement to insert unique individual form fields into ind_pda table
      conn.prepare('q_statement',
                   "insert into ind_pda (id, common_id, pda_date, incident_type,
                      page, total_pages, pda_team_fema, pda_team_state,
                      pda_team_sba, pda_team_hlo, af_own_single, af_own_multi,
                      af_own_mob, af_own_p_fl_ins, af_own_p_ho_ins, af_own_p_lo_inc,
                      af_own_num_inac, af_rent_single, af_rent_multi, af_rent_mob,
                      af_rent_p_fl_ins, af_rent_p_ho_ins, af_rent_p_lo_inc, af_rent_num_inac,
                      af_sec_single, af_sec_multi, af_sec_mob, mn_own_single,
                      mn_own_multi, mn_own_mob, mn_own_p_fl_ins, mn_own_p_ho_ins,
                      mn_own_p_lo_inc, mn_own_num_inac, mn_rent_single, mn_rent_multi,
                      mn_rent_mob, mn_rent_p_fl_ins, mn_rent_p_ho_ins, mn_rent_p_lo_inc,
                      mn_rent_num_inac, mn_sec_single, mn_sec_multi, mn_sec_mob,
                      mj_own_single, mj_own_multi, mj_own_mob, mj_own_p_fl_ins,
                      mj_own_p_ho_ins, mj_own_p_lo_inc, mj_own_num_inac, mj_rent_single,
                      mj_rent_multi, mj_rent_mob, mj_rent_p_fl_ins, mj_rent_p_ho_ins,
                      mj_rent_p_lo_inc, mj_rent_num_inac, mj_sec_single, mj_sec_multi,
                      mj_sec_mob, d_own_single, d_own_multi, d_own_mob,
                      d_own_p_fl_ins, d_own_p_ho_ins, d_own_p_lo_inc, d_own_num_inac,
                      d_rent_single, d_rent_multi, d_rent_mob, d_rent_p_fl_ins,
                      d_rent_p_ho_ins, d_rent_p_lo_inc, d_rent_num_inac, d_sec_single,
                      d_sec_multi, d_sec_mob, roads_bridges_damaged, households_impacted,
                      households_no_utilities, est_date_utility_restore, comments)
                    values($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
                      $15, $16, $17, $18, $19, $20, $21, $22, $23, $24, $25, $26, $27,
                      $28, $29, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $40,
                      $41, $42, $43, $44, $45, $46, $47, $48, $49, $50, $51, $52, $53,
                      $54, $55, $56, $57, $58, $59, $60, $61, $62, $63, $64, $65, $66,
                      $67, $68, $69, $70, $71, $72, $73, $74, $75, $76, $77, $78, $79,
                      $80, $81, $82, $83)")

      # execute prepared SQL statement
      conn.exec_prepared('q_statement', [v_id, v_id, v_pda_date, v_incident_type,
                      v_page, v_total_pages, v_pda_team_fema, v_pda_team_state,
                      v_pda_team_sba, v_pda_team_hlo, v_af_own_single, v_af_own_multi,
                      v_af_own_mob, v_af_own_p_fl_ins, v_af_own_p_ho_ins, v_af_own_p_lo_inc,
                      v_af_own_num_inac, v_af_rent_single, v_af_rent_multi, v_af_rent_mob,
                      v_af_rent_p_fl_ins, v_af_rent_p_ho_ins, v_af_rent_p_lo_inc, v_af_rent_num_inac,
                      v_af_sec_single, v_af_sec_multi, v_af_sec_mob, v_mn_own_single,
                      v_mn_own_multi, v_mn_own_mob, v_mn_own_p_fl_ins, v_mn_own_p_ho_ins,
                      v_mn_own_p_lo_inc, v_mn_own_num_inac, v_mn_rent_single, v_mn_rent_multi,
                      v_mn_rent_mob, v_mn_rent_p_fl_ins, v_mn_rent_p_ho_ins, v_mn_rent_p_lo_inc,
                      v_mn_rent_num_inac, v_mn_sec_single, v_mn_sec_multi, v_mn_sec_mob,
                      v_mj_own_single, v_mj_own_multi, v_mj_own_mob, v_mj_own_p_fl_ins,
                      v_mj_own_p_ho_ins, v_mj_own_p_lo_inc, v_mj_own_num_inac, v_mj_rent_single,
                      v_mj_rent_multi, v_mj_rent_mob, v_mj_rent_p_fl_ins, v_mj_rent_p_ho_ins,
                      v_mj_rent_p_lo_inc, v_mj_rent_num_inac, v_mj_sec_single, v_mj_sec_multi,
                      v_mj_sec_mob, v_d_own_single, v_d_own_multi, v_d_own_mob,
                      v_d_own_p_fl_ins, v_d_own_p_ho_ins, v_d_own_p_lo_inc, v_d_own_num_inac,
                      v_d_rent_single, v_d_rent_multi, v_d_rent_mob, v_d_rent_p_fl_ins,
                      v_d_rent_p_ho_ins, v_d_rent_p_lo_inc, v_d_rent_num_inac, v_d_sec_single,
                      v_d_sec_multi, v_d_sec_mob, v_roads_bridges_damaged, v_households_impacted,
                      v_households_no_utilities, v_est_date_utility_restore, v_comments])

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

end

seed_individual()
seed_individual_pda()