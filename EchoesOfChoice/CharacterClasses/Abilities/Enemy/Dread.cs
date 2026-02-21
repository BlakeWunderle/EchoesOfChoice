using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities.Enemy
{
    public class Dread : Ability
    {
        public Dread()
        {
            Name = "Dread";
            FlavorText = "Visions of damnation shatter the enemy's magical focus.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
