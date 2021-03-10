if(location.pathname.includes('/youtube/myvideos/')) {
  $(function () {
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

    function createButtonListener(favorite) {
      let cards = document.querySelectorAll('.video-swipe--card:not(.removed)');

      if (!cards.length) return false;

      let moveOutWidth = document.body.clientWidth * 2;

      let card = cards[0];
      let video_swipe_card_id = card.id;

      let video_swipe_card_id_hyphon_split_array = video_swipe_card_id.split('-');
    
      let youtube_video_id = video_swipe_card_id_hyphon_split_array[0]
      
      let youtube_video_unique_id;
      if(video_swipe_card_id_hyphon_split_array.length === 2){
        youtube_video_unique_id = video_swipe_card_id_hyphon_split_array[1]
      }
      else{
        youtube_video_unique_id = video_swipe_card_id_hyphon_split_array[1] + video_swipe_card_id_hyphon_split_array[2]
      }

      postReaction(youtube_video_id, youtube_video_unique_id,favorite);
      card.classList.add('removed');

      if (favorite == "like") {
        card.style.transform = 'translate(' + moveOutWidth + 'px, -100px) rotate(-30deg)';
      } else {
        card.style.transform = 'translate(-' + moveOutWidth + 'px, -100px) rotate(30deg)';
      }

      initCards();
    }

    function postReaction(youtube_video_id, youtube_video_unique_id, favorite) {
      $.ajax({
        url: "favorites.json",
        type: "POST",
        datatype: "json",
        data: {
          youtube_video_id: youtube_video_id,
          youtube_video_unique_id: youtube_video_unique_id,
          favorite: favorite,
        }
      })
      .done(function () {
        console.log("done!")
      })
    }
    
    $('#myvideo-like').on('click', function() {
      createButtonListener("like");
    })
    
    $('#myvideo-dislike').on('click', function() {
      createButtonListener("dislike");
    })
  
  });
}

