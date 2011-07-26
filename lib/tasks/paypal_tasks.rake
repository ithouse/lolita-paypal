require 'fileutils'

namespace :payapal do
  desc "Generate certificates"
  task :generate_certificate do
    fdcg = PaypalCertGenerator.new
    fdcg.start    
  end
end

class PaypalCertGenerator

  def initialize
    @cert_type = if (p = prompt(%^\nCertificate type?
      1. development
      2. staging
      3. production^)) == '1'
        'develpment'
      elsif p == '2'
        'staging'
      elsif p == '3'
        'production'
      end
    @destination = File.join(RAILS_ROOT, "config", "paypal", @cert_type)
    FileUtils.mkdir_p(@destination) unless File.exists?(@destination)
  end
  
  def start
    unless File.exists?("#{@destination}/my-prvkey.pem") && File.exists?("#{@destination}/my-pubcert.pem")
      gen_cert      
    end
  end
  
  def gen_cert
    `openssl genrsa -out #{@destination}/my-prvkey.pem 1024`
    `openssl req -new -key #{@destination}/my-prvkey.pem -x509 -days 365 -out #{@destination}/my-pubcert.pem`
    puts "\nLogin Paypal accout which is for business like this: aivils_1310470017_biz@gmail.com (testing)"
    puts "Go to Profile->More Options->Encrypted Payment Settings"
    puts "Click to \"PayPal Public Certificate\" paragraph \"Download\" button. You will get paypal_cert_pem.txt"
    puts "Rename  paypal_cert_pem.txt to paypal_cert.pem and copy into  #{@destination}"
    puts "Don't use certificate from https://developer.paypal.com/ !!!"
    puts "Upload Your public key #{@destination}/my-pubcert.pem on  paragraph  \"Your Public Certificates\""
    puts "Copy \"Cert ID\" into config files"
    prompt("To continue press [return]")
  end

  private

  def prompt q
    puts "#{q}"
    $stdout.flush
    $stdin.gets.strip
  end

end
