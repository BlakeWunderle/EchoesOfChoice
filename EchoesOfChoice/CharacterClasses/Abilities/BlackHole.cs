using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class BlackHole : Ability
    {
        public BlackHole()
        {
            Name = "Black Hole";
            FlavorText = "Tear open a rift in space that drags the enemy into crushing darkness.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 5;
        }
    }
}
