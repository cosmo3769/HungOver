import React from 'react';


export default function DonationForm() {
    return (
        <div>
            <form>
                <label>
                 Name:
                 <input type="text" name="name" />
                </label>
                <br />
                <label>
                 Location:
                 <input type="location" name="location" />
                </label>
                <br />
                <label>
                 Number of plates:
                 <input type="number" name="Plates" />
                </label>
                <br />
                <label>
                 Type:
                 <input type="text" name="type" placeholder="veg or nonveg"/>
                </label>
                <br />
<<<<<<< HEAD

                  <input type="submit" value="Submit" />
=======
                <input type="submit" value="Submit" />
>>>>>>> a4843837229c7b6945131de30244acef28b3e2d0
            </form>
            
        </div>
    )
}
