# ### Map of the internet
#
# You are given text file (rir.txt), "a map of the internet", that looks like this:
#
# ```
# 17.0.0.0 16777216 US-73b597984d74
# 38.0.0.0 16777216 US-b05fbdeef65e
# 39.0.0.0 256 CN-8173da22ea8b
# 39.0.1.0 256 AU-d97ba39c0486
# 39.0.2.0 512 CN-8173da22ea8b
# 39.0.4.0 1024 CN-8173da22ea8b
# 39.0.8.0 2048 CN-cc1064bf6999
# 39.0.16.0 4096 CN-cc1064bf6999
# 39.0.32.0 8192 CN-cc1064bf6999
# 39.0.64.0 16384 CN-cc1064bf6999
# 39.0.128.0 32768 CN-cc1064bf6999
# 39.1.0.0 65536 TW-751b788d8707
# 39.2.0.0 131072 JP-31d5e964d4b5
# 39.4.0.0 262144 KR-d5559ba5371b
# 39.8.0.0 524288 TW-0b14b3457557
# ```
#
# Each line contains a start ip address, number of ips, organization id. There might be gaps, there will never be 2 overflowing ranges.
#
# Your objective is to write a program that will for a given ip address find organization id.

# 39.0.0.0 256 CN-8173da22ea8b
# 39.0.0.0
# 39.0.0.1
# 39.0.0.2
# ...
# 39.0.0.255

# 39.0.2.0 512 CN-8173da22ea8b
# 39.0.3.255

# 39.0.3.123

# 40.0.0.0

class Organization < Struct.new(:upper_bound, :lower_bound, :blocks, :org_id);end

class OrganizationGroup < Struct.new(:search_array, :mapping);end

# array, hash (block -> org)
def parse_organizations(orgs)

  result = OrganizationGroup.new([], {})
  orgs.split("\n").each do |org|
    start, blocks, org_id = *org.split(' ')

    start_block = IPAddr.new(start).to_i
    end_block = start_block + blocks.to_i

    org = Organization.new(end_block, start_block, blocks, org_id)

    result.search_array << start_block
    result.mapping[start_block] = org
  end

  result
end

def find_organization_id(ipaddr, organization_group)

  ip_number = IPAddr.new(ipaddr).to_i
  lower_index = bsearch_upper_lower(ip_number, organization_group.search_array)

  # end_block, start_block
  # start_block, end_block

  # ip is in org
  org = organization_group.mapping[lower_index]
  if ip_number <= org.upper_bound
    return org.org_id
  else
    return nil
  end
end

def bsearch_upper_lower(n, search_array)
  start = 0
  ending = search_array.size - 1
  middle = ending / 2

  puts [n, search_array, start,ending, middle].inspect

  if search_array.size <= 2
    if n >= search_array.last
      search_array.last
    elsif n >= search_array.first
      search_array.first
    else
      -1
    end
  elsif n >= search_array[middle]
    bsearch_upper_lower(n, search_array[middle..ending])
  elsif n < search_array[middle]
    bsearch_upper_lower(n, search_array[start..(middle - 1)])
  end
end

f = File.open('rir.txt')
orgs = parse_organizations(f.read)
puts find_organization_id("39.0.64.1", orgs)
puts find_organization_id("39.0.65.1", orgs)
puts find_organization_id("39.8.5.255", orgs)

