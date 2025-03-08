const shadowRootObserver = new MutationObserver(mutations => {
    console.log("shadowRoot changed");
});

const playerObserver = new MutationObserver(mutations => {
    console.log("player changed");
    mutations.forEach(mutation => {
        if (mutation.type === "childList"){
            if (
                mutation.target.classList.contains("ytLottiePlayerHost") || 
                mutation.target.classList.contains("ytLottieBridgeHost") || 
                mutation.target.classList.contains("ytLottieBridgeNativePlayer")
            ) {
                console.log("Modificare in structura lui ytLottiePlayerHost sau ytLottieBridgeHost sau ytLottieBridgeNativePlayer si a copiilor");
                let shadowRootElement = document.querySelector('.ytLottieBridgeNativePlayer')?.shadowRoot;
                if (shadowRootElement != null){
                    console.log("Elementul shadowRoot exista (afisat din playerObserver)");
                }
            }
        }
    });
});

const bodyObserver = new MutationObserver(mutations => {
    console.log("body changed");
});
    
    

window.addEventListener("popstate", function(event) {
    console.log("History state popped:", event.state);

    shadowRootObserver.disconnect();
    playerObserver.disconnect();
    bodyObserver.disconnect();
    if (!/youtube\.com\/.*tv.*\/.*watch.*/i.test(window.location.href)){
        console.log("Bad URL");
        return;
    }

    let shadowRootElement = document.querySelector('.ytLottieBridgeNativePlayer')?.shadowRoot;
    let errorElement;
    if (shadowRootElement != null){
        console.log("Elementul shadowRoot exista");

        shadowRootObserver.observe(shadowRootElement, {
            childList: true,
            subtree: true
        });

        errorElement = shadowRootElement.querySelector('.error');
        if (errorElement != null){
            console.log("Elementul eroare exista");
        }
    }
    
    let playerElement = document.querySelector('.ytlr-progress-bar');
    if (playerElement != null){
        console.log("Elementul player exista");
        playerObserver.observe(playerElement, {
            childList: true,
            subtree: true
        });
        
    }

});