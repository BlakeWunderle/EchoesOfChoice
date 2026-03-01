using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class VoodooBolt : Ability
    {
        public VoodooBolt()
        {
            Name = "Voodoo Bolt";
            FlavorText = "Launch a bolt of dark voodoo energy at the target.";
            ModifiedStat = StatEnum.MagicAttack;
            Modifier = 7;
            impactedTurns = 0;
            UseOnEnemy = true;
            ManaCost = 4;
        }
    }
}
