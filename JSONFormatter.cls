public class JSONFormatter{
    public list<blocks> blocks;
    public class text{
        public String text;
        public String type;
        public Boolean emoji;
    }
    public class blocks{
        public text text;
        public String type;
        public accessory accessory;
        public List<fields> fields;
        public List<elements> elements;
    }
    
    public class fields{
        public String text;
        public String type;
    }
    
     public class elements{
        public text text;
        public String type;
        public String style;
        public String value;
    }
    
    public class accessory{
        public String type;
        public String image_url;
        public String alt_text;
    }
    
    
    
}