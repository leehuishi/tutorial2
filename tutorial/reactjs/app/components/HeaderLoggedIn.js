import React, { useEffect, useContext } from "react"
import { Link } from 'react-router-dom'
import DispatchContext from "../DispatchContext"
import { removeAuthTokenCookie } from "../RemoveCookieUtils";
import StateContext from "../StateContext"
import { Tooltip as ReactTooltip } from 'react-tooltip'


function HeaderLoggedIn(props){
    const appState = useContext(StateContext)
    const appDispatch = useContext(DispatchContext)

    async function handleLogout(){
        try{
            removeAuthTokenCookie()
            appDispatch({type: "logout"})
            // localStorage.removeItem("complexappToken") //removed using reducer
            appDispatch({ type: "flashMessage", value: "Logout Successful"})
        }
        catch(e){
            console.log("Logout unsuccessful")
        }
    }

    function handleSearchIcon(e){
        e.preventDefault();
        appDispatch({type:"openSearch"})
    }

    return (
        <div className="flex-row my-3 my-md-0">
            <a data-tooltip-id="search" data-tooltip-content="Search" onClick={handleSearchIcon} href="#" className="text-white mr-2 header-search-icon">
                <i className="fas fa-search"></i>
            </a>
            <ReactTooltip place="bottom" id="search" className="custom-tooltip" />
            {" "}

            <span onClick={() => appDispatch({type: "toggleChat"})} data-tooltip-id="chat" data-tooltip-content="Chat" className="mr-2 header-chat-icon text-white">
                <i className="fas fa-comment"></i>
                <span className="chat-count-badge text-white"> </span>
            </span>
            <ReactTooltip place="bottom" id="chat" className="custom-tooltip" />
            {" "}

            <Link data-tooltip-id="profile" data-tooltip-content="Profile" to={`/profile/${appState.user.username}`} className="mr-2">
                <img className="small-header-avatar" src="https://gravatar.com/avatar/b9408a09298632b5151200f3449434ef?s=128" />
            </Link>
            <ReactTooltip place="bottom" id="profile" className="custom-tooltip" />
            {" "}

            <Link className="btn btn-sm btn-success mr-2" to="/create-post">
                Create Post
            </Link>
            {" "}
            
            <button onClick={handleLogout} className="btn btn-sm btn-secondary">
                Sign Out
            </button>
        </div>
    )
}

export default HeaderLoggedIn