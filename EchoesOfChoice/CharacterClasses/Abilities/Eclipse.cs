using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Eclipse : Ability
    {
        public Eclipse()
        {
            Name = "Eclipse";
            FlavorText = "Blot out the light, weakening the enemy's magical resistance.";
            ModifiedStat = StatEnum.MagicDefense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
