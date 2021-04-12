class GeneratePdfJob < ActiveJob::Base
  queue_as :pdf
  
  def perform(re, docraptor, url)
      pdf = docraptor.create_doc(
        test:             Rails.env.production? ? false : true, 
        document_url:     url,
        name:             "#{re.uid}-#{re.title}",          
        document_type:    "pdf",                               
        pipeline: 8, 
        prince_options: {
          media: "print",    
        }
      )
  end
end