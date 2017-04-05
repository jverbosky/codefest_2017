require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

# Method to open a connection to the PostgreSQL database
def open_db()
  begin
    # connect to the database
    db_params = {
          host: ENV['host'],  # AWS link
          port:ENV['port'],  # AWS port, always 5432
          dbname:ENV['dbname'],
          user:ENV['dbuser'],
          password:ENV['dbpassword']
        }
    conn = PG::Connection.new(db_params)
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  end
end

# Method to return user hash from SQLite db for specified user
def get_data(user_name)
  begin
    conn = open_db()
    conn.prepare('q_statement',
                 "select *
                  from details
                  join numbers on details.id = numbers.details_id
                  join quotes on details.id = quotes.details_id
                  where details.name = '#{user_name}'")
    user_hash = conn.exec_prepared('q_statement')
    conn.exec("deallocate q_statement")
    return user_hash[0]
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Method to rearrange names for (top > down) then (left > right) column population
def rotate_names(names)
  quotient = names.count/3  # baseline for number of names per column
  names.count % 3 > 0 ? remainder = 1 : remainder = 0  # remainder to ensure no names dropped
  max_column_count = quotient + remainder  # add quotient & remainder to get max number of names per column
  matrix = names.each_slice(max_column_count).to_a    # names divided into three (inner) arrays
  results = matrix[0].zip(matrix[1], matrix[2]).flatten   # names rearranged (top > bottom) then (left > right) in table
  results.each_index { |name| results[name] ||= "" }  # replace any nils (due to uneven .zip) with ""
end

# Method to return array of sorted/transposed names from db for populating /list_users table
def get_names()
  begin
    names = []
    conn = open_db()
    conn.prepare('q_statement',
                 "select name from details order by name")
    query = conn.exec_prepared('q_statement')
    conn.exec("deallocate q_statement")
    query.each { |pair| names.push(pair["name"]) }
    names
    sorted = names.count > 3 ? rotate_names(names) : names  # rerrange names if more than 3 names
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Method to determine if value is too long or if user in current user hash is already in JSON file
def check_values(user_hash)
  flag = 0
  feedback = ""
  detail = ""
  user_hash.each do |key, value|
    flag = 2 if key == "age" && value.to_i > 120
    (flag = 3; detail = key) if key !~ /quote/ && value.length > 20
    flag = 4 if key == "quote" && value.length > 80
    flag = 5 if key == "name" && value =~ /[^a-zA-Z ]/
    (flag = 6; detail = key) if key =~ /age|n1|n2|n3/ && value =~ /[^0-9.,]/
  end
  users = get_names()
  users.each { |user| flag = 1 if user == user_hash["name"]}
  case flag
    when 1 then feedback = "We already have details for that person - please enter a different person."
    when 2 then feedback = "I don't think you're really that old - please try again."
    when 3 then feedback = "The value for '#{detail}' is too long - please try again with a shorter value."
    when 4 then feedback = "Your quote is too long - please try again with a shorter value."
    when 5 then feedback = "Your name should only contain letters - please try again."
    when 6 then feedback = "The value for '#{detail}' should only have numbers - please try again."
  end
  return feedback
end

# Method to add current user hash to db
def write_db(user_hash)
  feedback = check_values(user_hash)
  if feedback == ""
    begin
      conn = open_db() # open database for updating
      max_id = conn.exec("select max(id) from details")[0]  # determine current max index (id) in details table
      max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1  # set index variable based on current max index value
      v_name = user_hash["name"]  # prepare data from user_hash for database insert
      v_age = user_hash["age"]
      v_n1 = user_hash["n1"]
      v_n2 = user_hash["n2"]
      v_n3 = user_hash["n3"]
      v_quote = user_hash["quote"]
      conn.prepare('q_statement',
                   "insert into details (id, name, age)
                    values($1, $2, $3)")  # bind parameters
      conn.exec_prepared('q_statement', [v_id, v_name, v_age])
      conn.exec("deallocate q_statement")
      conn.prepare('q_statement',
                   "insert into numbers (id, details_id, n1, n2, n3)
                    values($1, $2, $3, $4, $5)")  # bind parameters
      conn.exec_prepared('q_statement', [v_id, v_id, v_n1, v_n2, v_n3])
      conn.exec("deallocate q_statement")
      conn.prepare('q_statement',
                   "insert into quotes (id, details_id, quote)
                    values($1, $2, $3)")  # bind parameters
      conn.exec_prepared('q_statement', [v_id, v_id, v_quote])
      conn.exec("deallocate q_statement")
    rescue PG::Error => e
      puts 'Exception occurred'
      puts e.message
    ensure
      conn.close if conn
    end
  end
end

# Updated for Steel City Codefest app
# Method to identify which column contains specified value
def match_column_ind(value)
  begin
    columns = ["municipality_name", "name", "street_address"]
    target = ""
    conn = open_db() # open database for updating
    columns.each do |column|  # determine which column contains the specified value
      query = "select " + column +
              " from common
               join ind on common.id = ind.common_id"
      conn.prepare('q_statement', query)
      rs = conn.exec_prepared('q_statement')
      conn.exec("deallocate q_statement")
      results = rs.values.flatten
      (results.include? value) ? (return column) : (target = "")
    end
    return target
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Updated for Steel City Codefest app
# Method to return hash of all values for record associated with specified value
def pull_records_ind(value)
  begin
    column = match_column(value)  # determine which column contains the specified value
    unless column == ""
      results = []  # array to hold all matching hashes
      conn = open_db()
      query = "select *
               from common
               join ind on common.id = ind.common_id
               where " + column + " = $1"  # bind parameter
      conn.prepare('q_statement', query)
      rs = conn.exec_prepared('q_statement', [value])
      conn.exec("deallocate q_statement")
      rs.each { |result| results.push(result) }
      return results
    else
      return [{"name" => "No matching record - please try again."}]
    end
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Updated for Steel City Codefest app
# Method to identify which column contains specified value
def match_column_ind_pda(value)
  begin
    columns = ["municipality_name", "pda_date", "incident_type"]
    target = ""
    conn = open_db() # open database for updating
    columns.each do |column|  # determine which column contains the specified value
      query = "select " + column +
              " from common
               join ind on common.id = ind_pda.common_id"
      conn.prepare('q_statement', query)
      rs = conn.exec_prepared('q_statement')
      conn.exec("deallocate q_statement")
      results = rs.values.flatten
      (results.include? value) ? (return column) : (target = "")
    end
    return target
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Updated for Steel City Codefest app
# Method to return hash of all values for record associated with specified value
def pull_records_ind_pda(value)
  begin
    column = match_column(value)  # determine which column contains the specified value
    unless column == ""
      results = []  # array to hold all matching hashes
      conn = open_db()
      query = "select *
               from common
               join ind on common.id = ind.common_id
               where " + column + " = $1"  # bind parameter
      conn.prepare('q_statement', query)
      rs = conn.exec_prepared('q_statement', [value])
      conn.exec("deallocate q_statement")
      rs.each { |result| results.push(result) }
      return results
    else
      return [{"name" => "No matching record - please try again."}]
    end
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Method to identify which table contains the specified column
def match_table(column)
  begin
    tables = ["details", "numbers", "quotes"]
    target = ""
    conn = open_db() # open database for updating
    tables.each do |table|  # determine which table contains the specified column
      conn.prepare('q_statement',
                   "select column_name
                    from information_schema.columns
                    where table_name = $1")  # bind parameter
      rs = conn.exec_prepared('q_statement', [table])
      p "rs: #{rs}"
      conn.exec("deallocate q_statement")
      columns = rs.values.flatten
      p "columns: #{columns}"
      target = table if columns.include? column
      p "target: #{target}"
    end
    return target
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Method to update any number of values in any number of tables
# - columns hash needs to contain id of current record that needs to be updated
# - order is not important (the id can be anywhere in the hash)
def update_values(columns)
  begin
    id = columns["id"]  # determine the id for the current record
    conn = open_db() # open database for updating
    columns.each do |column, value|  # iterate through columns hash for each column/value pair
      unless column == "id"  # we do NOT want to update the id
        table = match_table(column)  # determine which table contains the specified column
        # workaround for table name being quoted and column name used as bind parameter
        query = "update " + table + " set " + column + " = $2 where id = $1"
        conn.prepare('q_statement', query)
        rs = conn.exec_prepared('q_statement', [id, value])
        conn.exec("deallocate q_statement")
      end
    end
  rescue PG::Error => e
    puts 'Exception occurred'
    puts e.message
  ensure
    conn.close if conn
  end
end

# Method to return the sum of favorite numbers
def sum(n1, n2, n3)
  sum = n1.to_i + n2.to_i + n3.to_i
end

# Method to compare the sum of favorite numbers against the person's age
def compare(sum, age)
  comparison = (sum < age.to_i) ? "less" : "greater"
end

#-----------------
# Sandbox testing
#-----------------

# p get_data("John")

# user_hash = {"name" => "Jack", "age" => "37", "n1" => "8", "n2" => "16", "n3" => "24", "quote" => "You don't know... Jack."}
# write_db(user_hash)

# p get_names()

# p match_table("age")
# p match_table("quote")
# p match_table("n3")

# hash_1 = {"id" => "3", "age" => "74", "n1" => "100", "quote" => "Set your goals high, and don't stop till you get there."}
# hash_2 = {"age" => "93", "n3" => "77", "id" => "6", "quote" => "The harder the conflict, the more glorious the triumph."}
# hash_2 = {"name"=>"Fred", "age" => "93", "n1" => "8", "n2" => "9", "n3" => "10", "id" => "6", "quote" => "Let's try that again."}
# hash_2 = {"name"=>"Jen", "age" => "91", "n1" => "2", "n2" => "4", "n3" => "6", "id" => "6", "quote" => "If you fell down yesterday, stand up today."}
# hash_3 = {"name"=>"Pope John Paul", "age"=>"82", "n1"=>"10", "n2"=>"20", "n3"=>"820", "quote"=>"Kiss the ring.", "id"=>"9"}

# update_values(hash_1)
# update_values(hash_2)
# update_values(hash_3)

# p match_column("Pittsburgh City")  # "municipality_name"
# p match_column("Bill Roberts")  # "name"
# p match_column("116 Sunridge Dr")  # "street_address"
# p match_column("nothing")  #  ""

# p pull_records("Pittsburgh City")
# [{"id"=>"2", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"2", "name"=>"Phil Atwater", "street_address"=>"1511 Fallowfield Ave", "city"=>"Pittsburgh", "zip_code"=>"15216", "municipality_code"=>"700102", "date_damaged"=>"2017-03-30", "longitude"=>"-80.023639", "latitude"=>"40.412542", "location_notes"=>"Middle of block", "primary_home"=>nil, "renter"=>"Yes", "foundation_home"=>"5", "floor_frame_home"=>"12", "exterior_walls_home"=>"8", "roof_home"=>nil, "interior_walls_home"=>"8", "plumbing_home"=>"7", "heating_ac_home"=>"6", "electrical_home"=>"6", "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>"1", "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Exterior walls still crumbling", "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>nil, "assessor_name"=>"Rick McClain", "date_assessed"=>"2017-03-31"},
#  {"id"=>"3", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"3", "name"=>"Bill Roberts", "street_address"=>"4268 Stanton Ave", "city"=>"Pittsburgh", "zip_code"=>"15201", "municipality_code"=>"700102", "date_damaged"=>"2017-03-27", "longitude"=>"-79.943900", "latitude"=>"40.478869", "location_notes"=>"White house; away from street", "primary_home"=>"Yes", "renter"=>nil, "foundation_home"=>"3", "floor_frame_home"=>"7", "exterior_walls_home"=>nil, "roof_home"=>nil, "interior_walls_home"=>nil, "plumbing_home"=>"4", "heating_ac_home"=>nil, "electrical_home"=>"2", "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>nil, "affected_home"=>"2", "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Existing residual water - no drain-off", "flood_insurance"=>"Yes", "basement_water"=>"Yes", "first_floor_water"=>nil, "height_water"=>"2.000", "add_comments"=>nil, "assessor_name"=>"Susan Eitner", "date_assessed"=>"2017-03-28"},
#  {"id"=>"5", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"5", "name"=>"Mary St. John", "street_address"=>"5631 Carnegie", "city"=>"Pittsburgh", "zip_code"=>"15201", "municipality_code"=>"700102", "date_damaged"=>"2017-03-17", "longitude"=>"-79.946466", "latitude"=>"40.484571", "location_notes"=>"Light-brown siding", "primary_home"=>nil, "renter"=>"Yes", "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>"6", "roof_home"=>"9", "interior_walls_home"=>"2", "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>"1", "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Damage area roof & third floor walls only", "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>nil, "assessor_name"=>"Bill Baxter", "date_assessed"=>"2017-03-18"},
#  {"id"=>"10", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"10", "name"=>"Mike Presley", "street_address"=>"3766 Windgap Ave", "city"=>"Pittsburgh", "zip_code"=>"15204", "municipality_code"=>"700102", "date_damaged"=>"2017-03-09", "longitude"=>"-80.079105", "latitude"=>"40.458133", "location_notes"=>"Parking accessible", "primary_home"=>nil, "renter"=>"Yes", "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>nil, "roof_home"=>nil, "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>"6", "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>nil, "affected_home"=>"1", "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"No electrical utilities ONLY", "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>"Client belligerent", "assessor_name"=>"Michelle Thomas", "date_assessed"=>"2017-03-09"},
#  {"id"=>"11", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"11", "name"=>"Ralph Bronstein", "street_address"=>"1 Trimont Lane 820b", "city"=>"Pittsburgh", "zip_code"=>"15211", "municipality_code"=>"700102", "date_damaged"=>"2017-03-19", "longitude"=>"-80.020206", "latitude"=>"40.438221", "location_notes"=>"Top of the hill", "primary_home"=>"Yes", "renter"=>nil, "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>nil, "roof_home"=>"9", "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>"3", "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>nil, "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>"Multi-million dollar structure", "assessor_name"=>"Josey Wales", "date_assessed"=>"2017-03-19"},
#  {"id"=>"16", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"16", "name"=>"Richard Flanagan", "street_address"=>"405 E Carson St", "city"=>"Pittsburgh", "zip_code"=>"15203", "municipality_code"=>"700102", "date_damaged"=>"2017-04-04", "longitude"=>"-79.996076", "latitude"=>"40.429351", "location_notes"=>"House located next to Gaynor's School of Cooking", "primary_home"=>nil, "renter"=>"Yes", "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>"14", "roof_home"=>"9", "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>"6", "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>"1", "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>nil, "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>"Family evacuated to shelter; arrangements commenced for housing of pets", "assessor_name"=>"Rich Ruggieri", "date_assessed"=>"2017-04-05"},
#  {"id"=>"19", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"19", "name"=>"Gerry Fichte", "street_address"=>"5741 Kentucky Ave,", "city"=>"Pittsburgh", "zip_code"=>"15232", "municipality_code"=>"700102", "date_damaged"=>"2017-03-01", "longitude"=>"-79.928699", "latitude"=>"40.451191", "location_notes"=>"Kentucky Ave. @ Osterburg Way", "primary_home"=>"Yes", "renter"=>nil, "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>nil, "roof_home"=>nil, "interior_walls_home"=>nil, "plumbing_home"=>"10", "heating_ac_home"=>"10", "electrical_home"=>"6", "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>"2", "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Flooding damaged electrical system, and A/C System", "flood_insurance"=>"No", "basement_water"=>"Yes", "first_floor_water"=>"Yes", "height_water"=>"1.500", "add_comments"=>"Electrical contractor scheduled at 10 AM on 3/3/17", "assessor_name"=>"Bob Byrd", "date_assessed"=>"2017-03-02"}]

# p pull_records("Ralph Bronstein")
# [{"id"=>"11", "county"=>"Allegheny", "municipality_name"=>"Pittsburgh City", "common_id"=>"11", "name"=>"Ralph Bronstein", "street_address"=>"1 Trimont Lane 820b", "city"=>"Pittsburgh", "zip_code"=>"15211", "municipality_code"=>"700102", "date_damaged"=>"2017-03-19", "longitude"=>"-80.020206", "latitude"=>"40.438221", "location_notes"=>"Top of the hill", "primary_home"=>"Yes", "renter"=>nil, "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>nil, "roof_home"=>"9", "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>"3", "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>nil, "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>"Multi-million dollar structure", "assessor_name"=>"Josey Wales", "date_assessed"=>"2017-03-19"},
#  {"id"=>"12", "county"=>"Allegheny", "municipality_name"=>"Scott Township", "common_id"=>"12", "name"=>"Ralph Bronstein", "street_address"=>"421 Morrison Dr", "city"=>"Pittsburgh", "zip_code"=>"15216", "municipality_code"=>"730504", "date_damaged"=>"2017-04-03", "longitude"=>"-80.056103", "latitude"=>"40.390707", "location_notes"=>"Heading N on Cochran, make a right & follow cul-de-sac", "primary_home"=>"Yes", "renter"=>nil, "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>"3", "roof_home"=>"6", "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>"2", "minor_home"=>nil, "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Entire chimney destroyed, along with east-side wall", "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>nil, "assessor_name"=>"Barbara Schropshire", "date_assessed"=>"2017-04-03"}]

# p pull_records("116 Sunridge Dr")
# [{"id"=>"6", "county"=>"Allegheny", "municipality_name"=>"Mt Lebanon Twp", "common_id"=>"6", "name"=>"James Pasteur", "street_address"=>"116 Sunridge Dr", "city"=>"Pittsburgh", "zip_code"=>"15234", "municipality_code"=>"731201", "date_damaged"=>"2017-03-20", "longitude"=>"-80.046197", "latitude"=>"40.353598", "location_notes"=>nil, "primary_home"=>"Yes", "renter"=>nil, "foundation_home"=>nil, "floor_frame_home"=>nil, "exterior_walls_home"=>"2", "roof_home"=>"1", "interior_walls_home"=>nil, "plumbing_home"=>nil, "heating_ac_home"=>nil, "electrical_home"=>nil, "floor_frame_mobile"=>nil, "exterior_walls_mobile"=>nil, "roof_mobile"=>nil, "interior_walls_mobile"=>nil, "destroyed_home"=>nil, "major_home"=>nil, "minor_home"=>"1", "affected_home"=>nil, "inaccessible_home"=>nil, "destroyed_mobile"=>nil, "major_mobile"=>nil, "minor_mobile"=>nil, "affected_mobile"=>nil, "inaccessible_mobile"=>nil, "comments"=>"Tree fell into front left-side of house, causing slight structural damage to exterior walls and slight damage to roof", "flood_insurance"=>nil, "basement_water"=>nil, "first_floor_water"=>nil, "height_water"=>nil, "add_comments"=>nil, "assessor_name"=>"Bill Baxter", "date_assessed"=>"2017-03-21"}]

# p pull_records("nothing")
# [{"quote"=>"No matching record - please try again."}]