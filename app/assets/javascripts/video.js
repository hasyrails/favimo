window.addEventListener('DOMContentLoaded', function(){
  if(location.pathname.includes("/youtube/myvideos")) {
      let allCards = document.querySelectorAll('.video-swipe--card');
      let swipeContainer = document.querySelector('.video-swipe');
  
      function initCards() {
        let newCards = document.querySelectorAll('.video-swipe--card:not(.removed)');
  
        newCards.forEach(function (card, index) {
          card.style.zIndex = allCards.length - index;
          card.style.transform = 'scale(' + (20 - index) / 20 + ') translateY(-' + 30 * index + 'px)';
          card.style.opacity = (10 - index) / 10;
        });
  
        if (newCards.length == 0) {
          $(".no-user").addClass("is-active");
        }
      }
      
      initCards();
  
      function createButtonListener(reaction) {
        let cards = document.querySelectorAll('.video-swipe--card:not(.removed)');
  
        if (!cards.length) return false;
  
        let moveOutWidth = document.body.clientWidth * 2;
  
        let card = cards[0];
        let user_id = card.id;
  
        postReaction(user_id, reaction);
        card.classList.add('removed');
  
        if (reaction == "like") {
          card.style.transform = 'translate(' + moveOutWidth + 'px, -100px) rotate(-30deg)';
        } else {
          card.style.transform = 'translate(-' + moveOutWidth + 'px, -100px) rotate(30deg)';
        }
  
        initCards();
      }
  
      function postReaction(user_id, reaction) {
        $.ajax({
          url: "/videos",
          type: "POST",
          datatype: "json",
          data: {
            reaction: reaction,
          }
        })
        .done(function () {
          console.log("done!")
        })
      }
  
      $('#video-like').on('click', function() {
        createButtonListener("like");
      })
      
      $('#video-dislike').on('click', function() {
        createButtonListener("dislike");
      })
    
    }
});


