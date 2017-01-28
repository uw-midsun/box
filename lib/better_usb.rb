module BetterUSB

  def self.usbfilter_exists(vendor_id, product_id)
    machine_id_filepath = File.join(".vagrant", "machines", "default", "virtualbox", "id")

    if not File.exists? machine_id_filepath
      # VM hasn't been created yet
      return false
    end

    machine_id = File.read(machine_id_filepath)

    vm_info = `VBoxManage showvminfo #{machine_id}`
    filter_match = "VendorId:         #{vendor_id}\nProductId:        #{product_id}\n"

    vm_info.include? filter_match
  end

  def self.usbfilter_add(vb, vendor_id, product_id, filter_name)
    unless usbfilter_exists(vendor_id, product_id)
      vb.customize ["usbfilter", "add", "0",
                    "--target", :id,
                    "--name", filter_name,
                    "--vendorid", vendor_id,
                    "--productid", product_id
                   ]
    end
  end

end
