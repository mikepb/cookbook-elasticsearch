# Load configuration and credentials from data bag 'elasticsearch/aws' -
#
aws = Chef::DataBagItem.load('elasticsearch', 'aws') rescue {}
# ----------------------------------------------------------------------

default.elasticsearch[:plugin][:aws][:version] = '1.5.0'

# === AWS ===
# AWS configuration is set based on data bag values.
# You may choose to configure them in your node configuration instead.
#
default.elasticsearch[:gateway][:type]               = ( aws['gateway']['type']                rescue nil )
default.elasticsearch[:discovery][:type]             = ( aws['discovery']['type']              rescue nil )
default.elasticsearch[:gateway][:s3][:bucket]        = ( aws['gateway']['s3']['bucket']        rescue nil )

default.elasticsearch[:cloud][:ec2][:security_group] = ( aws['cloud']['ec2']['security_group'] rescue nil )
default.elasticsearch[:cloud][:aws][:access_key]     = ( aws['cloud']['aws']['access_key']     rescue nil )
default.elasticsearch[:cloud][:aws][:secret_key]     = ( aws['cloud']['aws']['secret_key']     rescue nil )

# === Engine Yard ===
# Engine Yard support.
#
if node.engineyard.environment.aws_secret_key and node.engineyard.environment.aws_secret_id
  default.elasticsearch[:gateway][:type]               ||= 's3'
  default.elasticsearch[:gateway][:s3][:bucket]        ||= "elasticsearch_#{node.engineyard.environment.name}"
  default.elasticsearch[:cloud][:aws][:access_key]     ||= node.engineyard.environment.aws_secret_key
  default.elasticsearch[:cloud][:aws][:secret_key]     ||= node.engineyard.environent.aws_secret_id
end
