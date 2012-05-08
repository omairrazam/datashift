# Copyright:: (c) Autotelik Media Ltd 2011
# Author ::   Tom Statter
# Date ::     Aug 2011
# License::   MIT
#
# Details::   Specs for Excel aspect of Active Record Loader
#
require File.dirname(__FILE__) + '/spec_helper'

if(Guards::jruby?)
  require 'erb'
  require 'excel_generator'

  include DataShift

  describe 'Excel Generator' do

    before(:all) do
      db_connect( 'test_file' )    # , test_memory, test_mysql

      # load our test model definitions - Project etc
      require File.join($DataShiftFixturePath, 'test_model_defs')  
   
      # handle migration changes or reset of test DB
      migrate_up

      db_clear()    # todo read up about proper transactional fixtures
      results_clear()

      @klazz = Project
      @assoc_klazz = Category
    end
  
    before(:each) do
      MethodDictionary.clear
      MethodDictionary.find_operators( @klazz )
      MethodDictionary.find_operators( @assoc_klazz )
    end
  
    it "should be able to create a new excel generator" do
      generator = ExcelGenerator.new( 'dummy.xls' )
      
      generator.should_not be_nil
    end
  
    it "should generate template .xls file from model" do

      expect = result_file('project_template_spec.xls')

      gen = ExcelGenerator.new( expect )
    
      gen.generate(Project)
 
      File.exists?(expect).should be_true
      
      puts "Can manually check file @ #{expect}"
    end

    it "should genrate a complex template .xls file from model" do

      expect= result_file('project_plus_assoc_template_spec.xls')

      gen = ExcelGenerator.new(expect)

      gen.generate_with_associations(Project)

      File.exists?(expect).should be_true

    end

  end
else
  puts "WARNING: skipped excel_generator_spec : Requires JRUBY - JExcelFile requires JAVA"
end # jruby