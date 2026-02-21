using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class CenterRing : Ability
    {
        public CenterRing()
        {
            Name = "Center Ring";
            FlavorText = "A commanding gesture that weakens the enemy's guard.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 4;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 2;
        }
    }
}
