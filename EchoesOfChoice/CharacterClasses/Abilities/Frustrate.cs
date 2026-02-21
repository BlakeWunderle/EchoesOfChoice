using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Frustrate : Ability
    {
        public Frustrate()
        {
            Name = "Frustrate";
            FlavorText = "Trash talk and get in an enemy's head. Decreases attacks.";
            ModifiedStat = StatEnum.Attack;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
