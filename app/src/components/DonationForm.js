import React, {useState} from 'react';
import app from '../configuration/firebase';
import 'firebase/firestore';
import Modal from 'react-bootstrap/Modal';
import Button from 'react-bootstrap/Button'

import {usePosition} from '../hooks/usePosition';

export default function DonationForm() {

    const [donorName, setDonorName]=useState("");
    const [numberofInvitedGuests, setNumberofInvitedGuests]= useState();
    const [numberOfGuestAttended, setNumberOfGuestAttended]= useState();
    const [numberOfPlates, setNumberOfPlates] = useState();
    const [platesLeft, setPlatesLeft]= useState();
    const [typeOfFood, setTypeOfFood]= useState("");
    const [dateOfEvent, setDateOfEvent]= useState();
    const [startTimeOfEvent, setStartTimeOfEvent]= useState();
    const [endTimeOfEvent, setEndTimeOfEvent]= useState();
    const [eventBefore, setEventBefore]= useState(false);
    const [show, setShow]= useState(false);
    

    const {
        latitude,
        longitude,
        timestamp,
      } = usePosition();

    // Donate Food
    function DonateFood(e) {
        e.preventDefault();
        const db = app.firestore();
        db.collection("DonateFood").add({
            name: `${donorName}`,
            Location: ({
                 lat: `${latitude}`,
                 long: `${longitude}`,
                 time: `${timestamp}`
            }),
            peopleInvited: `${numberofInvitedGuests}`,
            peopleTurnedUp: `${numberOfGuestAttended}`,
            platesOrdered: `${numberOfPlates}`,
            platesRemaining: `${platesLeft}`,
            typeOfFood: `${typeOfFood}`
        
        }).then((docRef) => {
            console.log("Document written with ID: ", docRef.id);
            console.log("done");
            window.location.reload();
        })
        .catch((error) => {
            console.error("Error adding document: ", error);
        });
    }

    function RegisterEvent(e) {
        e.preventDefault();
        const db = app.firestore();
        db.collection("RegisterEvent").add({
            name: `${donorName}`,
            Location: ({
                 lat: `${latitude}`,
                 long: `${longitude}`,
                 time: `${timestamp}`
            }),
            peopleInvited: `${numberofInvitedGuests}`,
            date: `${dateOfEvent}`,
            startTime: `${startTimeOfEvent}`,
            endTime: `${endTimeOfEvent}`,
            platesOrdered: `${numberOfPlates}`,
            typeOfFood: `${typeOfFood}`
        
        }).then((docRef) => {
            console.log("Document written with ID: ", docRef.id);
            console.log("done");
            window.location.reload();
        })
        .catch((error) => {
            console.error("Error adding document: ", error);
        });
    }

    const handleModalAfterEvent = ()=>{
        setEventBefore(false)
        setShow(true)
    }

    const handleModalBeforeEvent=()=>{
        setEventBefore(true)
        setShow(true)
    }

    return (
        <div>

            <Button onClick={handleModalBeforeEvent}>Register before event</Button>
            <Button onClick={handleModalAfterEvent}>Donate after the event</Button>

            <Modal show={show}>

            { !eventBefore ?
            <form onSubmit={DonateFood}>
                <label>
                 Name:
                 <input type="text" name="name" required value={donorName} onChange={e => setDonorName(e.target.value)} />
                </label>
                <br />
                <label>
                 Number of people invited:
                 <input type="number" name="peopleInvited" required value={numberofInvitedGuests} onChange={e => setNumberofInvitedGuests(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of people that turned up:
                 <input type="number" name="peopleTurnedUp" required value={numberOfGuestAttended} onChange={e => setNumberOfGuestAttended(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of plates ordered:
                 <input type="number" name="platesOrdered" required value={numberOfPlates} onChange={e => setNumberOfPlates(e.target.value)}/>
                </label>
                <br />
                <label>
                 Number of plates remaining:
                 <input type="number" name="platesRemaining" required value={platesLeft} onChange={e => setPlatesLeft(e.target.value)}/>
                </label>
                <br />
                <label>
                 Type of food:
                 <input type="radio" id="non-veg" name="typeOfFood" value="non-veg" checked={typeOfFood==="non-veg"}  onChange={()=> setTypeOfFood('non-veg')}/>
                 <label htmlFor="non-veg">Non-Veg</label><br />
                 <input type="radio" id="veg" name="typeofFood" value="veg" checked={typeOfFood==="veg"} onChange={() => setTypeOfFood("veg")} />
                 <label htmlFor="veg">Veg</label><br />
                </label>
                <br />
                <button type="submit" value="Submit">Submit</button>
            </form>

            :  
            
            <form onSubmit={RegisterEvent}>
            <label>
             Name:
             <input type="text" name="name" required value={donorName} onChange={e => setDonorName(e.target.value)} />
            </label>
            <br />
            <label>
             Number of people invited:
             <input type="number" name="peopleInvited" required value={numberofInvitedGuests} onChange={e => setNumberofInvitedGuests(e.target.value)}/>
            </label>
            <br />
            <label>
             Date of the event:
             <input type="date" name="date" required value={dateOfEvent} onChange={e => setDateOfEvent(e.target.value)}/>
            </label>
            <br />
            <label>
                Start Time:
                <input type="time" name="startTime" required value={startTimeOfEvent} onChange={e => setStartTimeOfEvent(e.target.value)} />

                End Time:
                <input type="time" name="endTime" required value={endTimeOfEvent} onChange={e => setEndTimeOfEvent(e.target.value)} />
                
            </label>
            <br />
            <label>
             Number of plates ordered:
             <input type="number" name="platesOrdered" required value={numberOfPlates} onChange={e => setNumberOfPlates(e.target.value)}/>
            </label>
            <br />
            <label>
             Type of food:
             <input type="radio" id="non-veg" name="typeOfFood" value="non-veg" checked={typeOfFood==="non-veg"}  onChange={()=> setTypeOfFood('non-veg')}/>
             <label htmlFor="non-veg">Non-Veg</label><br />
             <input type="radio" id="veg" name="typeofFood" value="veg" checked={typeOfFood==="veg"} onChange={() => setTypeOfFood("veg")} />
             <label htmlFor="veg">Veg</label><br />
            </label>
            <br />
            <button type="submit" value="Submit">Submit</button>
        </form>
            }
            </Modal>
        </div>
    )
}