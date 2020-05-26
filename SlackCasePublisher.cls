public with sharing class SlackCasePublisher {
     
    private static final String slackURL = 'https://hooks.slack.com/services/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';
     
    public class Cases {
        @InvocableVariable(label='Case Name')
        public String caseName;
        @InvocableVariable(label='Status')
        public String status;
        @InvocableVariable(label='Account Name')
        public String acctname;
        @InvocableVariable(label='Contact Name')
        public String conName;
         @InvocableVariable(label='Case Id')
         public String caseid;
    }
     
    @InvocableMethod(label='Post case update to Slack')
    public static void postToSlack(List<Cases> caseList) {
        
        Cases c = caseList[0]; // If bulk, only post first to avoid overloading Slack channel
        String baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();

        String ms = 'You have a new case: *' + c.caseName + '*\n*<' + baseUrl + '/' + c.caseid + '|' + c.acctname + ' - Status: ' + c.status +'>*';
        
        
        
        JSONFormatter J = new JSONFormatter();
        J.blocks = new list<JSONFormatter.blocks>();
        JSONFormatter.blocks jb = new JSONFormatter.blocks();
        JSONFormatter.text jt = new JSONFormatter.text();
        jb.type = 'section';
        jt.type = 'mrkdwn';
        jt.text = ms;
        jb.text = jt;
        J.blocks.add(jb);
        
        JSONFormatter.blocks jb1 = new JSONFormatter.blocks();
        List<JSONFormatter.fields> fList = new list<JSONFormatter.fields>();
        JSONFormatter.text jt1 = new JSONFormatter.text();
        JSONFormatter.fields jf = new JSONFormatter.fields();
        JSONFormatter.fields jf1 = new JSONFormatter.fields();
        JSONFormatter.fields jf2 = new JSONFormatter.fields();
        JSONFormatter.fields jf3 = new JSONFormatter.fields();
        JSONFormatter.fields jf4 = new JSONFormatter.fields();
        
        jf.type = 'mrkdwn';
        jf.text = '*Case Name :*\n'+ c.caseName ;
        
        jf1.type = 'mrkdwn';
        jf1.text = '*Case Status :*\n'+ c.status ;
        
        jf2.type = 'mrkdwn';
        jf2.text = '*Account Name :*\n'+ c.acctname ;
        
        jf3.type = 'mrkdwn';
        jf3.text = '*Contact Name :*\n'+ c.conName ;
        
        jf4.type = 'mrkdwn';
        jf4.text = '*Submitted Time :*\n'+ system.today();
        
        fList.add(jf);
        fList.add(jf1);
        fList.add(jf2);
        fList.add(jf3);
        fList.add(jf4);
        
        JSONFormatter.accessory jac1 = new JSONFormatter.accessory();
        jac1.type = 'image';
        jac1.image_url = 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fappexchange.salesforce.com%2Fconsulting&psig=AOvVaw1e7uETXOzluW7g4X14RtL9&ust=1587668284953000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCJi5lrnb_OgCFQAAAAAdAAAAABAD';
        jac1.alt_text = 'computer thumbnail';
        
        jb1.accessory = jac1;

        
        jb1.type = 'section';
        jt1.type = 'mrkdwn';
        jt1.text = 'Hello Hello 1';
       // jb1.text = jt1;
        jb1.fields = fList;
        J.blocks.add(jb1);
        
        
        
        JSONFormatter.blocks jb2 = new JSONFormatter.blocks();
        jb2.type = 'actions';
        List<JSONFormatter.elements> EleList = new list<JSONFormatter.elements>();
        JSONFormatter.elements je = new JSONFormatter.elements();
        JSONFormatter.elements je1 = new JSONFormatter.elements();
        
        je.type = 'button';
        je.style = 'primary';
        je.value = 'www.google.com';
        
        JSONFormatter.text jt2 = new JSONFormatter.text();
        jt2.emoji = true;
        jt2.text = 'Acknowledge';
        jt2.type = 'plain_text';
        
        je.text = jt2;
        EleList.add(je);
        jb2.elements = EleList;
        
       // J.blocks.add(jb2);
        
        
        
        System.debug('J > ' + J);
        String body = JSON.serialize(J,true);    
        sYSTEM.debug('BOST >  ' + body);
        
        System.enqueueJob(new QueueableSlackCall(slackURL, 'POST', body));
    }
     
    public class QueueableSlackCall implements System.Queueable, Database.AllowsCallouts {
         
        private final String url;
        private final String method;
        private final String body;
         
        public QueueableSlackCall(String url, String method, String body) {
            this.url = url;
            this.method = method;
            this.body = body;
        }
         
        public void execute(System.QueueableContext ctx) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(url);
            req.setMethod(method);
            req.setBody(body);
            Http http = new Http();
            HttpResponse res = http.send(req);
        }
 
    }
    
}