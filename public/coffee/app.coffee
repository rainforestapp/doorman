App = Ember.Application.create()

App.Store = DS.Store.extend
  revision: 12
  adapter: 'DS.FixtureAdapter'

App.Router.map ->
  @resource 'log'
  @resource 'modules'

App.Module = DS.Model.extend
  title: DS.attr 'string'
  author: DS.attr 'string'
  intro: DS.attr 'string'
  extended: DS.attr 'string'
  publishedAt: DS.attr 'date'

App.Module.FIXTURES = [{
  id: 1
  title: 'Oh hai world'
  author: 'Fredskis'
  publishedAt: new Date '12-27-2012'
  intro: 'Leberkäse spare ribs beef kielbasa frankfurter, corned beef strip steak jerky. Bacon flank meatball jowl, hamburger boudin jerky sirloin rump venison turkey drumstick tenderloin.'
  extended: 'Leberkäse spare ribs beef kielbasa frankfurter, corned beef strip steak jerky. Bacon flank meatball jowl, hamburger boudin jerky sirloin rump venison turkey drumstick tenderloin. Corned beef turkey beef, hamburger capicola spare ribs ham cow chuck pork chop ribeye tenderloin bresaola venison tongue. Ground round pancetta tongue frankfurter pork chop drumstick, andouille tenderloin pastrami ribeye kielbasa pork belly biltong corned beef chicken. Brisket jowl tenderloin, tri-tip bresaola ball tip spare ribs sirloin. Boudin turkey jowl andouille, tenderloin pork chop sirloin kielbasa capicola. Tongue short loin corned beef tri-tip flank.Leberkäse beef ribs pork chop, meatloaf rump fatback filet mignon. Frankfurter spare ribs sirloin drumstick, bresaola jerky salami. Short loin shoulder chicken swine venison pork belly. Ball tip spare ribs turducken flank swine. Boudin pork ground round, flank turducken bresaola pastrami chuck sausage rump cow tongue t-bone. Brisket corned beef sirloin, ribeye turducken beef shankle pork belly boudin short ribs pork. Brisket chuck shank rump.Prosciutto corned beef ribeye boudin tri-tip. Strip steak venison jerky, short ribs ham t-bone tongue. Pancetta rump short loin, short ribs sirloin tongue pig jowl cow beef ribs. Leberkäse short ribs drumstick cow, shankle bacon jerky frankfurter. Bacon ball tip fatback cow beef ribs kielbasa. Beef ribs meatball cow, drumstick ham tri-tip sirloin short loin biltong pastrami. Leberkäse pork chop shankle, short loin meatloaf ham salami beef ribs ball tip sirloin venison flank.'
}, {
  id: 2
  title: 'Something else'
  author: 'Fredskis'
  publishedAt: new Date '12-10-2012'
  intro: 'Learn how to build a blog reading application from start to finish using Ember.js.'
  extended: 'Leberkäse spare ribs beef kielbasa frankfurter, corned beef strip steak jerky. Bacon flank meatball jowl, hamburger boudin jerky sirloin rump venison turkey drumstick tenderloin.'
}]

App.ModulesRoute = Ember.Route.extend
  model: ->
    return App.Module.find()